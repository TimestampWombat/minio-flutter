import 'dart:io';

import 'package:http/http.dart' as http;
import 'package:json_annotation/json_annotation.dart';

import 'package:minio_flutter/src/errors/minio_exception.dart';
import '../digest.dart';
import '../signer.dart';
import '../time.dart';
import '../utils/http_url.dart' as HttpUrl;
import 'assume_role_base_provider.dart';
import 'credentials.dart';

part 'assume_role_provider.g.dart';

class AssumeRoleProvider extends AssumeRoleBaseProvider {
  final String accessKey;
  final String secretKey;
  final String region;
  late final String contentSha256;
  late final http.BaseRequest request;

  AssumeRoleProvider(
      String stsEndpoint,
      this.accessKey,
      this.secretKey,
      int? durationSeconds,
      String? policy,
      String? region,
      String? roleArn,
      String? roleSessionName,
      String? externalId,
      super.customHttpClient)
      : region = region ?? "",
        assert(accessKey.isEmpty, "Access key must not be empty") {
    Uri url = Uri.parse(stsEndpoint);

    if (externalId != null &&
        (externalId.length < 2 || externalId.length > 1224)) {
      throw ArgumentError("Length of ExternalId must be in between 2 and 1224");
    }

    String host = "${url.host}:${url.port}";
    // ignore port when port and service matches i.e HTTP -> 80, HTTPS -> 443
    if ((url.scheme == "http" && url.port == 80) ||
        url.scheme == "https" && url.port == 443) {
      host = url.host;
    }

    HttpUrl.Builder urlBuilder = newUrlBuilder(
        url,
        "AssumeRole",
        getValidDurationSeconds(durationSeconds),
        policy,
        roleArn,
        roleSessionName);
    if (externalId != null) {
      urlBuilder.addQueryParameter("ExternalId", externalId);
    }

    String data = urlBuilder.build().query;
    contentSha256 = Digest.sha256HashFromString(data);
    request = http.Request("POST", url);
    request.headers["Host"] = host;
    request.headers[HttpHeaders.contentTypeHeader] =
        "application/x-www-form-urlencoded";
  }

  @override
  http.BaseRequest getRequest() {
    try {
      return Signer.signV4Sts(
          request
            ..headers["x-amz-date"] =
                DateTimeX.nowUtc().format(Time.AMZ_DATE_FORMAT),
          region,
          accessKey,
          secretKey,
          contentSha256);
    } catch (e) {
      throw ProviderException("Signature calculation failed: $e");
    }
  }

  @override
  AssumeRoleResponse xmlUnmarshal(Map<String, dynamic> json) =>
      AssumeRoleResponse.fromJson(json);
}

/// Object representation of response XML of AssumeRole API.
/// @Root(name = "AssumeRoleResponse", strict = false)
/// @Namespace(reference = "https://sts.amazonaws.com/doc/2011-06-15/")
@JsonSerializable(fieldRename: FieldRename.pascal)
class AssumeRoleResponse implements Response {
  // @Path(value = "AssumeRoleResult")
  // @Element(name = "Credentials")
  final Credentials credentials;

  AssumeRoleResponse(this.credentials);

  @override
  Credentials getCredentials() => credentials;

  factory AssumeRoleResponse.fromJson(Map<String, dynamic> json) =>
      _$AssumeRoleResponseFromJson(json);
  Map<String, dynamic> toJson() => _$AssumeRoleResponseToJson(this);
}
