import 'package:json_annotation/json_annotation.dart';

import 'assume_role_base_provider.dart' as AssumeRoleBaseProvider;
import 'credentials.dart';
import 'http_url.dart' as HttpUrl;
import 'jwt.dart';
import 'web_identity_client_grants_provider.dart';

part 'web_identity_provider.g.dart';

/// Credential provider using <a
/// href="https://docs.aws.amazon.com/STS/latest/APIReference/API_AssumeRoleWithWebIdentity.html">AssumeRoleWithWebIdentity
/// API</a>.
class WebIdentityProvider extends WebIdentityClientGrantsProvider {
  WebIdentityProvider(
      super.supplier,
      super.stsEndpoint,
      super.durationSeconds,
      super.policy,
      super.roleArn,
      super.roleSessionName,
      super.customHttpClient);

  @override
  HttpUrl.Builder newUrlBuilderFromJwt(Jwt jwt) {
    HttpUrl.Builder urlBuilder = newUrlBuilder(
        stsEndpoint,
        "AssumeRoleWithWebIdentity",
        getDurationSeconds(jwt.expiry),
        policy,
        roleArn,
        (roleArn != null && roleSessionName == null)
            ? '${DateTime.now().millisecondsSinceEpoch}'
            : roleSessionName);
    return urlBuilder.addQueryParameter("WebIdentityToken", jwt.token);
  }

  @override
  AssumeRoleBaseProvider.Response xmlUnmarshal(Map<String, dynamic> json) {
    return WebIdentityResponse.fromJson(json);
  }
}

/// Object representation of response XML of AssumeRoleWithWebIdentity API.
// @Root(name = "AssumeRoleWithWebIdentityResponse", strict = false)
// @Namespace(reference = "https://sts.amazonaws.com/doc/2011-06-15/")

@JsonSerializable()
class WebIdentityResponse implements AssumeRoleBaseProvider.Response {
  // @Path(value = "AssumeRoleWithWebIdentityResult")
  // @Element(name = "Credentials")
  final Credentials credentials;

  WebIdentityResponse(this.credentials);

  @override
  Credentials getCredentials() {
    return credentials;
  }

  factory WebIdentityResponse.fromJson(Map<String, dynamic> json) =>
      _$WebIdentityResponseFromJson(json);
  Map<String, dynamic> toJson() => _$WebIdentityResponseToJson(this);
}
