import 'dart:io';

import 'package:json_annotation/json_annotation.dart';

import 'assume_role_base_provider.dart' hide Response;
import 'assume_role_base_provider.dart' as AssumeRoleBaseProviderP
    show Response;
import 'credentials.dart';
import 'package:http/http.dart' as http;
import 'http_url.dart' as HttpUrl;

part 'certificate_identity_provider.g.dart';

class CertificateIdentityProvider extends AssumeRoleBaseProvider {
  late final http.BaseRequest request;

  CertificateIdentityProvider(
      String stsEndpoint,
      SecurityContext? securityContext,
      int? durationSeconds,
      http.Client? client)
      : super(client, securityContext) {
    Uri url = Uri.parse(stsEndpoint);
    if (!url.isHttps()) {
      throw ArgumentError("STS endpoint scheme must be HTTPS");
    }

    HttpUrl.Builder urlBuilder = newUrlBuilder(
        url,
        "AssumeRoleWithCertificate",
        AssumeRoleBaseProvider.getValidDurationSeconds(durationSeconds),
        null,
        null,
        null);
    url = urlBuilder.build();

    request = http.Request("POST", url);
    request.headers[HttpHeaders.contentTypeHeader] = "application/octet-stream";
  }

  @override
  http.BaseRequest getRequest() {
    return request;
  }

  @override
  CertificateIdentityResponse xmlUnmarshal(Map<String, dynamic> json) {
    return CertificateIdentityResponse.fromJson(json);
  }
}

/// Object representation of response XML of AssumeRoleWithCertificate API.
// @Root(name = "AssumeRoleWithCertificateResponse", strict = false)
// @Namespace(reference = "https://sts.amazonaws.com/doc/2011-06-15/")
@JsonSerializable(fieldRename: FieldRename.pascal)
class CertificateIdentityResponse implements AssumeRoleBaseProviderP.Response {
  // @Path(value = "AssumeRoleWithCertificateResult")
  // @Element(name = "Credentials")
  final Credentials credentials;

  CertificateIdentityResponse(this.credentials);

  @override
  Credentials getCredentials() {
    return credentials;
  }

  factory CertificateIdentityResponse.fromJson(Map<String, dynamic> json) =>
      _$CertificateIdentityResponseFromJson(json);
  Map<String, dynamic> toJson() => _$CertificateIdentityResponseToJson(this);
}
