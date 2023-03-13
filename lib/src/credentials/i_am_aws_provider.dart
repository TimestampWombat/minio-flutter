import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:http/http.dart' as http;
import 'package:json_annotation/json_annotation.dart';

import 'package:minio_flutter/src/messages/response_date.dart';
import 'package:minio_flutter/src/utils/responsex.dart';
import '../errors/minio_exception.dart';
import 'credentials.dart';
import 'environment_provider.dart';
import 'jwt.dart';
import 'provider.dart';
import 'web_identity_provider.dart';

part 'i_am_aws_provider.g.dart';

/// Credential provider using <a
/// href="http://docs.aws.amazon.com/AWSEC2/latest/UserGuide/iam-roles-for-amazon-ec2.html">IAM roles
/// for Amazon EC2</a>.
class IamAwsProvider extends EnvironmentProvider {
  // Custom endpoint to fetch IAM role credentials.
  late final Uri? customEndpoint;
  late final http.Client httpClient;
  //  final ObjectMapper mapper;
  Credentials? credentials;

  IamAwsProvider(String? endpoint, http.Client? customHttpClient) {
    customEndpoint = endpoint != null ? Uri.parse(endpoint) : null;
    // HTTP/1.1 is only supported in default client because of HTTP/2 in OkHttpClient cause 5
    // minutes timeout on program exit.
    httpClient = (customHttpClient != null) ? customHttpClient : http.Client();

    // this.mapper =
    //     JsonMapper.builder()
    //         .configure(DeserializationFeature.FAIL_ON_UNKNOWN_PROPERTIES, false)
    //         .configure(MapperFeature.ACCEPT_CASE_INSENSITIVE_PROPERTIES, true)
    //         .build();
  }

  void checkLoopbackHost(Uri url) async {
    try {
      for (InternetAddress addr in await InternetAddress.lookup(url.host)) {
        if (!addr.isLoopback) {
          throw ProviderException("${url.host} is not loopback only host");
        }
      }
    } catch (e) {
      throw ProviderException("Host in $url is not loopback address");
    }
  }

  FutureOr<Credentials> fetchCredentialsFromFile(String tokenFile) async {
    Uri? url = customEndpoint;
    if (url == null) {
      String? region = getProperty("AWS_REGION");
      url = Uri.parse((region == null)
          ? "https://sts.amazonaws.com"
          : "https://sts.$region.amazonaws.com");
    }

    Provider provider = WebIdentityProvider(() {
      try {
        final data = File(tokenFile).readAsStringSync();
        return Jwt(data, 0);
      } catch (e) {
        throw ProviderException("Error in reading file $tokenFile", e);
      }
    }, url.toString(), null, null, getProperty("AWS_ROLE_ARN"),
        getProperty("AWS_ROLE_SESSION_NAME"), httpClient);
    credentials = await provider.fetch();
    return credentials!;
  }

  FutureOr<Credentials> fetchCredentials(
      Uri url, String tokenHeader, String? token) async {
    Map<String, String> headers = <String, String>{};
    if (token != null && token.isNotEmpty) {
      headers[tokenHeader] = token;
    }
    try {
      http.Response response = await httpClient.get(url, headers: headers);
      if (response.notSuccessful()) {
        throw ProviderException(
            "$url failed with HTTP status code ${response.statusCode}");
      }

      EcsCredentials creds = EcsCredentials.fromJson(json.decode(response
          .body)); //mapper.readValue(response.body().charStream(), EcsCredentials.class);
      if (creds.code != null && creds.code != "Success") {
        throw ProviderException(
            "$url failed with code ${creds.code} and message ${creds.message}");
      }
      return creds.toCredentials();
    } catch (e) {
      throw ProviderException("Unable to parse response", e);
    }
  }

  Future<String> fetchImdsToken() async {
    Uri? url = customEndpoint;
    if (url == null) {
      url = Uri.parse("http://169.254.169.254/latest/api/token");
    } else {
      url = Uri(scheme: url.scheme, host: url.host, path: "/latest/api/token");
    }
    String token = "";
    try {
      http.Response response = await httpClient
          .put(url, headers: {"X-aws-ec2-metadata-token-ttl-seconds": "21600"});
      if (response.isSuccessful()) token = response.body;
    } catch (e) {
      token = "";
    }
    return token;
  }

  Future<String> getIamRoleName(Uri url, String? token) async {
    List<String> roleNames = [];
    Map<String, String> headers = <String, String>{};
    if (token != null && token.isNotEmpty) {
      headers["X-aws-ec2-metadata-token"] = token;
    }
    try {
      http.Response response = await httpClient.get(url, headers: headers);
      if (!response.isSuccessful()) {
        throw ProviderException(
            "$url failed with HTTP status code ${response.statusCode}");
      }

      roleNames = response.body.split("\\R");
    } catch (e) {
      throw ProviderException("Unable to parse response", e);
    }

    if (roleNames.isEmpty) {
      throw ProviderException("No IAM roles attached to EC2 service $url");
    }

    return roleNames[0];
  }

  Future<Uri> getIamRoleNamedUrl(String token) async {
    Uri? url = customEndpoint;

    if (url == null) {
      url = Uri.parse(
          "http://169.254.169.254/latest/meta-data/iam/security-credentials/");
    } else {
      url = Uri(
          scheme: url.scheme,
          host: url.host,
          path: "/latest/meta-data/iam/security-credentials/");
    }

    String roleName = await getIamRoleName(url, token);

    return Uri(
        scheme: url.scheme,
        host: url.host,
        pathSegments: [...url.pathSegments, roleName]);
  }

  @override
  FutureOr<Credentials> fetch() async {
    if (credentials != null && !credentials!.isExpired()) {
      return credentials!;
    }

    Uri? url = customEndpoint;
    String? tokenFile = getProperty("AWS_WEB_IDENTITY_TOKEN_FILE");
    if (tokenFile != null) {
      credentials = await fetchCredentialsFromFile(tokenFile);
      return credentials!;
    }

    String tokenHeader = "Authorization";
    String? token = getProperty("AWS_CONTAINER_AUTHORIZATION_TOKEN");
    if (getProperty("AWS_CONTAINER_CREDENTIALS_RELATIVE_URI") != null) {
      url ??= Uri(
          scheme: "http",
          host: "169.254.170.2",
          path: getProperty("AWS_CONTAINER_CREDENTIALS_RELATIVE_URI"));
    } else if (getProperty("AWS_CONTAINER_CREDENTIALS_FULL_URI") != null) {
      url ??= Uri.parse(getProperty("AWS_CONTAINER_CREDENTIALS_FULL_URI")!);
      checkLoopbackHost(url);
    } else {
      token = await fetchImdsToken();
      tokenHeader = "X-aws-ec2-metadata-token";
      url = await getIamRoleNamedUrl(token);
    }

    credentials = await fetchCredentials(url, tokenHeader, token);
    return credentials!;
  }
}

@JsonSerializable(fieldRename: FieldRename.pascal)
class EcsCredentials {
  @JsonKey(name: "AccessKeyID")
  final String accessKey;

  @JsonKey(name: "SecretAccessKey")
  final String secretKey;

  @JsonKey(name: "Token")
  final String sessionToken;

  @JsonKey(fromJson: ResponseDate.fromString, toJson: ResponseDate.toJson)
  final ResponseDate? expiration;

  final String? code;

  final String? message;

  EcsCredentials(this.accessKey, this.secretKey, this.sessionToken,
      this.expiration, this.code, this.message);

  Credentials toCredentials() {
    return Credentials(accessKey, secretKey, sessionToken, expiration);
  }

  factory EcsCredentials.fromJson(Map<String, dynamic> json) =>
      _$EcsCredentialsFromJson(json);
  Map<String, dynamic> toJson() => _$EcsCredentialsToJson(this);
}
