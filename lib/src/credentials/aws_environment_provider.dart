import 'dart:async';

import 'package:minio_flutter/src/credentials/credentials.dart';

import 'environment_provider.dart';

class AwsEnvironmentProvider extends EnvironmentProvider {
  String getAccessKey() {
    return getProperty("AWS_ACCESS_KEY_ID") ?? getProperty("AWS_ACCESS_KEY")!;
  }

  String getSecretKey() {
    return getProperty("AWS_SECRET_ACCESS_KEY") ??
        getProperty("AWS_SECRET_KEY")!;
  }

  @override
  FutureOr<Credentials> fetch() {
    return Credentials(
        getAccessKey(), getSecretKey(), getProperty("AWS_SESSION_TOKEN"), null);
  }
}
