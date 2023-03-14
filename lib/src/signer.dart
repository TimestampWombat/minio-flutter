import 'dart:collection';

import 'package:collection/collection.dart';
import 'package:convert/convert.dart';
import 'package:cryptography/cryptography.dart';
import 'package:http/http.dart' as http;
import 'package:quiver/collection.dart';

import 'package:minio_flutter/src/utils/http_url.dart' as HttpUrl;
import 'digest.dart';
import 's3escaper.dart';
import 'time.dart';

/// Amazon AWS S3 signature V4 signer.
class Signer {
  //
  // Excerpts from @lsegal - https://github.com/aws/aws-sdk-js/issues/659#issuecomment-120477258
  //
  // * User-Agent
  // This is ignored from signing because signing this causes problems with generating pre-signed
  // URLs (that are executed by other agents) or when customers pass requests through proxies, which
  // may modify the user-agent.
  //
  // * Authorization
  // Is skipped for obvious reasons.
  //
  // * Accept-Encoding
  // Some S3 servers like Hitachi Content Platform do not honour this header for signature
  // calculation.
  //
  static final Set<String> IGNORED_HEADERS =
      UnmodifiableSetView({"accept-encoding", "authorization", "user-agent"});
  static final Set<String> PRESIGN_IGNORED_HEADERS = UnmodifiableSetView({
    "accept-encoding",
    "authorization",
    "user-agent",
    "content-md5",
    "x-amz-content-sha256",
    "x-amz-date",
    "x-amz-security-token"
  });

  http.BaseRequest? request;
  String? contentSha256;
  late DateTime date;
  late String region;
  String? accessKey;
  String secretKey;
  String? prevSignature;

  late String scope;
  Map<String, String> canonicalHeaders = <String, String>{};
  late String signedHeaders;
  late Uri url;
  late String canonicalQueryString;
  late String canonicalRequest;
  late String canonicalRequestHash;
  late String stringToSign;
  late List<int> signingKey;
  late String signature;
  late String authorization;

  /// Create Signer object for V4.
  ///
  /// @param request HTTP Request object.
  /// @param contentSha256 SHA-256 hash of request payload.
  /// @param date Date to be used to sign the request.
  /// @param region Amazon AWS region for the request.
  /// @param accessKey Access Key string.
  /// @param secretKey Secret Key string.
  /// @param prevSignature Previous signature of chunk upload.
  Signer(this.request, this.contentSha256, this.date, this.region,
      this.accessKey, this.secretKey, this.prevSignature);

  void setScope(String serviceName) {
    scope =
        "${date.format(Time.SIGNER_DATE_FORMAT)}/$region/$serviceName/aws4_request";
  }

  void setCanonicalHeaders(Set<String> ignored_headers) {
    canonicalHeaders = <String, String>{};

    request!.headers.forEach((name, value) {
      String signedHeader = name.toLowerCase();
      if (!ignored_headers.contains(signedHeader)) {
        // Convert and add header values as per
        // https://docs.aws.amazon.com/general/latest/gr/sigv4-create-canonical-request.html
        // * Header having multiple values should be converted to comma separated values.
        // * Multi-spaced value of header should be trimmed to single spaced value.
        // TODO: java版本的Headers是Map<String, List<String>>, 不知道直接处理List<String>使用','拼接的直接操作是否会有问题,待验证
        canonicalHeaders[signedHeader] = value.replaceAll("( +)", " ");
      }
    });
    signedHeaders = canonicalHeaders.keys.join(';');
  }

  void setCanonicalQueryString() {
    String encodedQuery = url.query;
    if (encodedQuery.isEmpty) {
      canonicalQueryString = "";
      return;
    }

    // Building a multimap which only order keys, ordering values is not performed
    // until MinIO server supports it.
    Multimap<String, String> signedQueryParams = Multimap();

    for (String queryParam in encodedQuery.split("&")) {
      List<String> tokens = queryParam.split("=");
      if (tokens.length > 1) {
        signedQueryParams.add(tokens[0], tokens[1]);
      } else {
        signedQueryParams.add(tokens[0], "");
      }
    }

    canonicalQueryString = signedQueryParams.keys
        .sorted((a, b) => a.compareTo(b))
        .map((e) => '$e=${signedQueryParams[e]}')
        .join('&');
  }

  void setCanonicalRequest() {
    setCanonicalHeaders(IGNORED_HEADERS);
    url = request!.url;
    setCanonicalQueryString();

    // CanonicalRequest =
    //   HTTPRequestMethod + '\n' +
    //   CanonicalURI + '\n' +
    //   CanonicalQueryString + '\n' +
    //   CanonicalHeaders + '\n' +
    //   SignedHeaders + '\n' +
    //   HexEncode(Hash(RequestPayload))
    canonicalRequest =
        "${request!.method}\n${url.path}\n$canonicalQueryString\n${canonicalHeaders.entries.map((e) => '${e.key}=${e.value}').join("\n")}\n\n$signedHeaders\n$contentSha256";

    canonicalRequestHash = Digest.sha256HashFromString(canonicalRequest);
  }

  void setStringToSign() {
    stringToSign =
        "AWS4-HMAC-SHA256\n${date.format(Time.AMZ_DATE_FORMAT)}\n$scope\n$canonicalRequestHash";
  }

  void setChunkStringToSign() {
    stringToSign =
        "AWS4-HMAC-SHA256-PAYLOAD\n${date.format(Time.AMZ_DATE_FORMAT)}\n$scope\n$prevSignature\n${Digest.sha256HashFromString("")}\n$contentSha256";
  }

  void setSigningKey(String serviceName) async {
    String aws4SecretKey = "AWS4$secretKey";

    List<int> dateKey = await sumHmac(aws4SecretKey.codeUnits,
        date.format(Time.SIGNER_DATE_FORMAT).codeUnits);

    List<int> dateRegionKey = await sumHmac(dateKey, region.codeUnits);

    List<int> dateRegionServiceKey =
        await sumHmac(dateRegionKey, serviceName.codeUnits);

    signingKey = await sumHmac(dateRegionServiceKey, "aws4_request".codeUnits);
  }

  void setSignature() async {
    List<int> digest = await sumHmac(signingKey, stringToSign.codeUnits);
    signature = hex.encode(digest);
  }

  void setAuthorization() {
    authorization =
        "AWS4-HMAC-SHA256 Credential=$accessKey/$scope, SignedHeaders=$signedHeaders, Signature=$signature";
  }

  /// Returns chunk signature calculated using given arguments.
  static String getChunkSignature(String chunkSha256, DateTime date,
      String region, String secretKey, String prevSignature) {
    Signer signer =
        Signer(null, chunkSha256, date, region, null, secretKey, prevSignature);
    signer.setScope("s3");
    signer.setChunkStringToSign();
    signer.setSigningKey("s3");
    signer.setSignature();

    return signer.signature;
  }

  /// Returns signed request object for given request, region, access key and secret key.
  static http.BaseRequest signV4(String serviceName, http.BaseRequest request,
      String region, String accessKey, String secretKey, String contentSha256) {
    DateTime date =
        DateTimeX.parse(request.headers["x-amz-date"], Time.AMZ_DATE_FORMAT)!;

    Signer signer = Signer(
        request, contentSha256, date, region, accessKey, secretKey, null);
    signer.setScope(serviceName);
    signer.setCanonicalRequest();
    signer.setStringToSign();
    signer.setSigningKey(serviceName);
    signer.setSignature();
    signer.setAuthorization();

    return request..headers["Authorization"] = signer.authorization;
  }

  /// Returns signed request of given request for S3 service.
  static http.BaseRequest signV4S3(http.BaseRequest request, String region,
      String accessKey, String secretKey, String contentSha256) {
    return signV4("s3", request, region, accessKey, secretKey, contentSha256);
  }

  /// Returns signed request of given request for STS service.
  static http.BaseRequest signV4Sts(http.BaseRequest request, String region,
      String accessKey, String secretKey, String contentSha256) {
    return signV4("sts", request, region, accessKey, secretKey, contentSha256);
  }

  void setPresignCanonicalRequest(int expires) {
    setCanonicalHeaders(PRESIGN_IGNORED_HEADERS);

    HttpUrl.Builder urlBuilder = request!.url.newBuilder();
    urlBuilder.addEncodedQueryParameter(S3Escaper.encode("X-Amz-Algorithm"),
        S3Escaper.encode("AWS4-HMAC-SHA256"));
    urlBuilder.addEncodedQueryParameter(S3Escaper.encode("X-Amz-Credential"),
        S3Escaper.encode("$accessKey/$scope"));
    urlBuilder.addEncodedQueryParameter(S3Escaper.encode("X-Amz-Date"),
        S3Escaper.encode(date.format(Time.AMZ_DATE_FORMAT)));
    urlBuilder.addEncodedQueryParameter(
        S3Escaper.encode("X-Amz-Expires"), S3Escaper.encode("expires"));
    urlBuilder.addEncodedQueryParameter(S3Escaper.encode("X-Amz-SignedHeaders"),
        S3Escaper.encode(signedHeaders));
    url = urlBuilder.build();

    setCanonicalQueryString();

    canonicalRequest =
        "${request!.method}\n${url.path}\n$canonicalQueryString\n${canonicalHeaders.entries.map((e) => '${e.key}:${e.value}').join('\n')}" +
            "\n\n$signedHeaders\n$contentSha256";

    canonicalRequestHash = Digest.sha256HashFromString(canonicalRequest);
  }

  /// Returns pre-signed HttpUrl object for given request, region, access key, secret key and expires
  /// time.
  static Uri presignV4(http.BaseRequest request, String region,
      String accessKey, String secretKey, int expires) {
    String contentSha256 = "UNSIGNED-PAYLOAD";
    DateTime date =
        DateTimeX.parse(request.headers["x-amz-date"], Time.AMZ_DATE_FORMAT)!;

    Signer signer = Signer(
        request, contentSha256, date, region, accessKey, secretKey, null);
    signer.setScope("s3");
    signer.setPresignCanonicalRequest(expires);
    signer.setStringToSign();
    signer.setSigningKey("s3");
    signer.setSignature();

    return signer.url
        .newBuilder()
        .addEncodedQueryParameter(S3Escaper.encode("X-Amz-Signature"),
            S3Escaper.encode(signer.signature))
        .build();
  }

  /// Returns credential string of given access key, date and region.
  static String credential(String accessKey, DateTime date, String region) {
    return "$accessKey/${date.format(Time.SIGNER_DATE_FORMAT)}/$region/s3/aws4_request";
  }

  /// Returns pre-signed post policy string for given stringToSign, secret key, date and region.
  static String postPresignV4(
      String stringToSign, String secretKey, DateTime date, String region) {
    Signer signer = Signer(null, null, date, region, null, secretKey, null);
    signer.stringToSign = stringToSign;
    signer.setSigningKey("s3");
    signer.setSignature();

    return signer.signature;
  }

  /// Returns HMacSHA256 digest of given key and data.
  static Future<List<int>> sumHmac(List<int> key, List<int> data) async {
    SecretKey secretKey = SecretKey(key);
    Mac mac = await Hmac.sha256().calculateMac(data, secretKey: secretKey);
    return mac.bytes;
  }
}
