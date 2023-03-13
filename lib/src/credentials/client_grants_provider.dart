import 'package:http/http.dart' as http;
import 'package:json_annotation/json_annotation.dart';

import '../utils/supplier.dart';
import 'assume_role_base_provider.dart' as AssumeRoleBaseProvider;
import 'credentials.dart';
import 'http_url.dart' as HttpUrl;
import 'jwt.dart';
import 'web_identity_client_grants_provider.dart';

part 'client_grants_provider.g.dart';
/// Credential provider using <a
/// href="https://github.com/minio/minio/blob/master/docs/sts/client-grants.md">AssumeRoleWithClientGrants
/// API</a>.
class ClientGrantsProvider extends WebIdentityClientGrantsProvider {
  ClientGrantsProvider(Supplier<Jwt> supplier, String stsEndpoint,
      int? durationSeconds, String? policy, http.Client? customHttpClient)
      : super(supplier, stsEndpoint, durationSeconds, policy, null, null,
            customHttpClient);

  @override
  HttpUrl.Builder newUrlBuilderFromJwt(Jwt jwt) {
    HttpUrl.Builder urlBuilder = newUrlBuilder(
        stsEndpoint,
        "AssumeRoleWithClientGrants",
        getDurationSeconds(jwt.expiry),
        policy,
        null,
        null);
    return urlBuilder.addQueryParameter("Token", jwt.token);
  }
  
  @override
  AssumeRoleBaseProvider.Response xmlUnmarshal(Map<String, dynamic> json) {
    return ClientGrantsResponse.fromJson(json);
  }
}

/// Object representation of response XML of AssumeRoleWithClientGrants API.
// @Root(name = "AssumeRoleWithClientGrantsResponse", strict = false)
// @Namespace(reference = "https://sts.amazonaws.com/doc/2011-06-15/")
@JsonSerializable()
class ClientGrantsResponse implements AssumeRoleBaseProvider.Response {
  // @Path(value = "AssumeRoleWithClientGrantsResult")
  // @Element(name = "Credentials")
  final Credentials credentials;

  ClientGrantsResponse(this.credentials);

  @override
  Credentials getCredentials() {
    return credentials;
  }
  factory ClientGrantsResponse.fromJson(Map<String, dynamic> json) =>
      _$ClientGrantsResponseFromJson(json);
  Map<String, dynamic> toJson() => _$ClientGrantsResponseToJson(this);
}
