import 'dart:collection';

import 'package:http/http.dart' as http;
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
   static final Set<String> PRESIGN_IGNORED_HEADERS =
     UnmodifiableSetView({
          "accept-encoding",
          "authorization",
          "user-agent",
          "content-md5",
          "x-amz-content-sha256",
          "x-amz-date",
          "x-amz-security-token"});

   http.BaseRequest request;
   String contentSha256;
   DateTime date;
   String region;
   String accessKey;
   String secretKey;
   String prevSignature;

   String scope;
   Map<String, String> canonicalHeaders;
   String signedHeaders;
   Uri url;
   String canonicalQueryString;
   String canonicalRequest;
   String canonicalRequestHash;
   String stringToSign;
   List<int> signingKey;
   String signature;
   String authorization;

  /// Create new Signer object for V4.
  ///
  /// @param request HTTP Request object.
  /// @param contentSha256 SHA-256 hash of request payload.
  /// @param date Date to be used to sign the request.
  /// @param region Amazon AWS region for the request.
  /// @param accessKey Access Key string.
  /// @param secretKey Secret Key string.
  /// @param prevSignature Previous signature of chunk upload.
   Signer(
      this. request,
      this. contentSha256,
      this. date,
      this. region,
      this. accessKey,
      this. secretKey,
      this. prevSignature) ;

   void setScope(String serviceName) {
    this.scope =
        this.date.format(Time.SIGNER_DATE_FORMAT)
            + "/"
            + this.region
            + "/"
            + serviceName
            + "/aws4_request";
  }

   void setCanonicalHeaders(Set<String> ignored_headers) {
    this.canonicalHeaders = new TreeMap<>();

    Headers headers = this.request.headers();
    for (String name : headers.names()) {
      String signedHeader = name.toLowerCase(Locale.US);
      if (!ignored_headers.contains(signedHeader)) {
        // Convert and add header values as per
        // https://docs.aws.amazon.com/general/latest/gr/sigv4-create-canonical-request.html
        // * Header having multiple values should be converted to comma separated values.
        // * Multi-spaced value of header should be trimmed to single spaced value.
        this.canonicalHeaders.put(
            signedHeader,
            headers.values(name).stream()
                .map(
                    value -> {
                      return value.replaceAll("( +)", " ");
                    })
                .collect(Collectors.joining(",")));
      }
    }

    this.signedHeaders = Joiner.on(";").join(this.canonicalHeaders.keySet());
  }

   void setCanonicalQueryString() {
    String encodedQuery = this.url.encodedQuery();
    if (encodedQuery == null) {
      this.canonicalQueryString = "";
      return;
    }

    // Building a multimap which only order keys, ordering values is not performed
    // until MinIO server supports it.
    Multimap<String, String> signedQueryParams =
        MultimapBuilder.treeKeys().arrayListValues().build();

    for (String queryParam : encodedQuery.split("&")) {
      String[] tokens = queryParam.split("=");
      if (tokens.length > 1) {
        signedQueryParams.put(tokens[0], tokens[1]);
      } else {
        signedQueryParams.put(tokens[0], "");
      }
    }

    this.canonicalQueryString =
        Joiner.on("&").withKeyValueSeparator("=").join(signedQueryParams.entries());
  }

   void setCanonicalRequest() throws NoSuchAlgorithmException {
    setCanonicalHeaders(IGNORED_HEADERS);
    this.url = this.request.url();
    setCanonicalQueryString();

    // CanonicalRequest =
    //   HTTPRequestMethod + '\n' +
    //   CanonicalURI + '\n' +
    //   CanonicalQueryString + '\n' +
    //   CanonicalHeaders + '\n' +
    //   SignedHeaders + '\n' +
    //   HexEncode(Hash(RequestPayload))
    this.canonicalRequest =
        this.request.method()
            + "\n"
            + this.url.encodedPath()
            + "\n"
            + this.canonicalQueryString
            + "\n"
            + Joiner.on("\n").withKeyValueSeparator(":").join(this.canonicalHeaders)
            + "\n\n"
            + this.signedHeaders
            + "\n"
            + this.contentSha256;

    this.canonicalRequestHash = Digest.sha256Hash(this.canonicalRequest);
  }

   void setStringToSign() {
    this.stringToSign =
        "AWS4-HMAC-SHA256"
            + "\n"
            + this.date.format(Time.AMZ_DATE_FORMAT)
            + "\n"
            + this.scope
            + "\n"
            + this.canonicalRequestHash;
  }

   void setChunkStringToSign() throws NoSuchAlgorithmException {
    this.stringToSign =
        "AWS4-HMAC-SHA256-PAYLOAD"
            + "\n"
            + this.date.format(Time.AMZ_DATE_FORMAT)
            + "\n"
            + this.scope
            + "\n"
            + this.prevSignature
            + "\n"
            + Digest.sha256Hash("")
            + "\n"
            + this.contentSha256;
  }

   void setSigningKey(String serviceName)
      throws NoSuchAlgorithmException, InvalidKeyException {
    String aws4SecretKey = "AWS4" + this.secretKey;

    byte[] dateKey =
        sumHmac(
            aws4SecretKey.getBytes(StandardCharsets.UTF_8),
            this.date.format(Time.SIGNER_DATE_FORMAT).getBytes(StandardCharsets.UTF_8));

    byte[] dateRegionKey = sumHmac(dateKey, this.region.getBytes(StandardCharsets.UTF_8));

    byte[] dateRegionServiceKey =
        sumHmac(dateRegionKey, serviceName.getBytes(StandardCharsets.UTF_8));

    this.signingKey =
        sumHmac(dateRegionServiceKey, "aws4_request".getBytes(StandardCharsets.UTF_8));
  }

   void setSignature() throws NoSuchAlgorithmException, InvalidKeyException {
    byte[] digest = sumHmac(this.signingKey, this.stringToSign.getBytes(StandardCharsets.UTF_8));
    this.signature = BaseEncoding.base16().encode(digest).toLowerCase(Locale.US);
  }

   void setAuthorization() {
    this.authorization =
        "AWS4-HMAC-SHA256 Credential="
            + this.accessKey
            + "/"
            + this.scope
            + ", SignedHeaders="
            + this.signedHeaders
            + ", Signature="
            + this.signature;
  }

  /// Returns chunk signature calculated using given arguments.
   static String getChunkSignature(
      String chunkSha256, ZonedDateTime date, String region, String secretKey, String prevSignature)
      throws NoSuchAlgorithmException, InvalidKeyException {
    Signer signer = new Signer(null, chunkSha256, date, region, null, secretKey, prevSignature);
    signer.setScope("s3");
    signer.setChunkStringToSign();
    signer.setSigningKey("s3");
    signer.setSignature();

    return signer.signature;
  }

  /// Returns signed request object for given request, region, access key and secret key.
   static Request signV4(
      String serviceName,
      Request request,
      String region,
      String accessKey,
      String secretKey,
      String contentSha256)
      throws NoSuchAlgorithmException, InvalidKeyException {
    ZonedDateTime date = ZonedDateTime.parse(request.header("x-amz-date"), Time.AMZ_DATE_FORMAT);

    Signer signer = new Signer(request, contentSha256, date, region, accessKey, secretKey, null);
    signer.setScope(serviceName);
    signer.setCanonicalRequest();
    signer.setStringToSign();
    signer.setSigningKey(serviceName);
    signer.setSignature();
    signer.setAuthorization();

    return request.newBuilder().header("Authorization", signer.authorization).build();
  }

  /// Returns signed request of given request for S3 service.
   static Request signV4S3(
      Request request, String region, String accessKey, String secretKey, String contentSha256)
      throws NoSuchAlgorithmException, InvalidKeyException {
    return signV4("s3", request, region, accessKey, secretKey, contentSha256);
  }

  /// Returns signed request of given request for STS service.
   static Request signV4Sts(
      Request request, String region, String accessKey, String secretKey, String contentSha256)
      throws NoSuchAlgorithmException, InvalidKeyException {
    return signV4("sts", request, region, accessKey, secretKey, contentSha256);
  }

   void setPresignCanonicalRequest(int expires) throws NoSuchAlgorithmException {
    setCanonicalHeaders(PRESIGN_IGNORED_HEADERS);

    HttpUrl.Builder urlBuilder = this.request.url().newBuilder();
    urlBuilder.addEncodedQueryParameter(
        S3Escaper.encode("X-Amz-Algorithm"), S3Escaper.encode("AWS4-HMAC-SHA256"));
    urlBuilder.addEncodedQueryParameter(
        S3Escaper.encode("X-Amz-Credential"), S3Escaper.encode(this.accessKey + "/" + this.scope));
    urlBuilder.addEncodedQueryParameter(
        S3Escaper.encode("X-Amz-Date"), S3Escaper.encode(this.date.format(Time.AMZ_DATE_FORMAT)));
    urlBuilder.addEncodedQueryParameter(
        S3Escaper.encode("X-Amz-Expires"), S3Escaper.encode(Integer.toString(expires)));
    urlBuilder.addEncodedQueryParameter(
        S3Escaper.encode("X-Amz-SignedHeaders"), S3Escaper.encode(this.signedHeaders));
    this.url = urlBuilder.build();

    setCanonicalQueryString();

    this.canonicalRequest =
        this.request.method()
            + "\n"
            + this.url.encodedPath()
            + "\n"
            + this.canonicalQueryString
            + "\n"
            + Joiner.on("\n").withKeyValueSeparator(":").join(this.canonicalHeaders)
            + "\n\n"
            + this.signedHeaders
            + "\n"
            + this.contentSha256;

    this.canonicalRequestHash = Digest.sha256Hash(this.canonicalRequest);
  }

  /// Returns pre-signed HttpUrl object for given request, region, access key, secret key and expires
  /// time.
   static HttpUrl presignV4(
      Request request, String region, String accessKey, String secretKey, int expires)
      throws NoSuchAlgorithmException, InvalidKeyException {
    String contentSha256 = "UNSIGNED-PAYLOAD";
    ZonedDateTime date = ZonedDateTime.parse(request.header("x-amz-date"), Time.AMZ_DATE_FORMAT);

    Signer signer = new Signer(request, contentSha256, date, region, accessKey, secretKey, null);
    signer.setScope("s3");
    signer.setPresignCanonicalRequest(expires);
    signer.setStringToSign();
    signer.setSigningKey("s3");
    signer.setSignature();

    return signer
        .url
        .newBuilder()
        .addEncodedQueryParameter(
            S3Escaper.encode("X-Amz-Signature"), S3Escaper.encode(signer.signature))
        .build();
  }

  /// Returns credential string of given access key, date and region.
   static String credential(String accessKey, ZonedDateTime date, String region) {
    return accessKey
        + "/"
        + date.format(Time.SIGNER_DATE_FORMAT)
        + "/"
        + region
        + "/s3/aws4_request";
  }

  /// Returns pre-signed post policy string for given stringToSign, secret key, date and region.
   static String postPresignV4(
      String stringToSign, String secretKey, ZonedDateTime date, String region)
      throws NoSuchAlgorithmException, InvalidKeyException {
    Signer signer = new Signer(null, null, date, region, null, secretKey, null);
    signer.stringToSign = stringToSign;
    signer.setSigningKey("s3");
    signer.setSignature();

    return signer.signature;
  }

  /// Returns HMacSHA256 digest of given key and data.
   static byte[] sumHmac(byte[] key, byte[] data)
      throws NoSuchAlgorithmException, InvalidKeyException {
    Mac mac = Mac.getInstance("HmacSHA256");

    mac.init(new SecretKeySpec(key, "HmacSHA256"));
    mac.update(data);

    return mac.doFinal();
  }
}
