import 'package:http/http.dart' as http;
import 'package:json_annotation/json_annotation.dart';

import '../utils/http_url.dart' as HttpUrl;
import 'assume_role_base_provider.dart';
import 'credentials.dart';

part 'ldap_identity_provider.g.dart';

/// Credential provider using <a
/// href="https://github.com/minio/minio/blob/master/docs/sts/ldap.md">AssumeRoleWithLDAPIdentity
/// API</a>.
class LdapIdentityProvider extends AssumeRoleBaseProvider {
  late final http.BaseRequest request;

  LdapIdentityProvider(
    String stsEndpoint,
    String? ldapUsername,
    String ldapPassword,
    http.Client? customHttpClient, [
    int? durationSeconds,
    String? policy,
  ]) : super(customHttpClient) {
    Uri url = Uri.parse(stsEndpoint);
    if (ldapUsername == null || ldapUsername.isEmpty) {
      throw ArgumentError("LDAP username must be provided");
    }

    HttpUrl.Builder urlBuilder = newUrlBuilder(
        url,
        "AssumeRoleWithLDAPIdentity",
        getValidDurationSeconds(durationSeconds),
        policy,
        null,
        null);
    url = urlBuilder
        .addQueryParameter("LDAPUsername", ldapUsername)
        .addQueryParameter("LDAPPassword", ldapPassword)
        .build();
    request = http.Request("POST", url);
  }

  @override
  http.BaseRequest getRequest() {
    return request;
  }

  @override
  LdapIdentityResponse xmlUnmarshal(Map<String, dynamic> json) {
    return LdapIdentityResponse.fromJson(json);
  }
}

/// Object representation of response XML of AssumeRoleWithLDAPIdentity API.
// @Root(name = "AssumeRoleWithLDAPIdentityResponse", strict = false)
// @Namespace(reference = "https://sts.amazonaws.com/doc/2011-06-15/")
@JsonSerializable(fieldRename: FieldRename.pascal)
class LdapIdentityResponse implements Response {
  // @Path(value = "AssumeRoleWithLDAPIdentityResult")
  // @Element(name = "Credentials")
  final Credentials credentials;

  LdapIdentityResponse(this.credentials);

  @override
  Credentials getCredentials() {
    return credentials;
  }

  factory LdapIdentityResponse.fromJson(Map<String, dynamic> json) =>
      _$LdapIdentityResponseFromJson(json);
  Map<String, dynamic> toJson() => _$LdapIdentityResponseToJson(this);
}
