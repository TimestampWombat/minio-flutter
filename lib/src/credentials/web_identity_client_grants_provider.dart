import 'dart:io';

import 'package:http/http.dart' as http;
import 'package:time/time.dart';

import '../utils/http_url.dart' as HttpUrl;
import '../utils/supplier.dart';
import 'assume_role_base_provider.dart';
import 'jwt.dart';

/// Base class of WebIdentity and ClientGrants providers.
abstract class WebIdentityClientGrantsProvider extends AssumeRoleBaseProvider {
  static final int MIN_DURATION_SECONDS = 15.minutes.inSeconds;
  static final int MAX_DURATION_SECONDS = 7.days.inSeconds;
  final Supplier<Jwt> supplier;
  final Uri stsEndpoint;
  final int? durationSeconds;
  final String? policy;
  final String? roleArn;
  final String? roleSessionName;

  WebIdentityClientGrantsProvider(
      this.supplier,
      String stsEndpoint,
      this.durationSeconds,
      this.policy,
      this.roleArn,
      this.roleSessionName,
      http.Client? customHttpClient)
      : stsEndpoint = Uri.parse(stsEndpoint),
        super(customHttpClient);

  int getDurationSeconds(int expiry) {
    if (durationSeconds != null && durationSeconds! > 0) {
      expiry = durationSeconds!;
    }

    if (expiry > MAX_DURATION_SECONDS) {
      return MAX_DURATION_SECONDS;
    }

    if (expiry <= 0) {
      return expiry;
    }

    return (expiry < MIN_DURATION_SECONDS) ? MIN_DURATION_SECONDS : expiry;
  }

  @override
  http.BaseRequest getRequest() {
    Jwt jwt = supplier.get();
    HttpUrl.Builder urlBuilder = newUrlBuilderFromJwt(jwt);
    return http.Request("POST", urlBuilder.build())
      ..headers[HttpHeaders.contentTypeHeader] = "application/octet-stream";
  }

  HttpUrl.Builder newUrlBuilderFromJwt(Jwt jwt);
}
