import 'dart:async';

import 'credentials.dart';
import 'environment_provider.dart';

class MinioEnvironmentProvider extends EnvironmentProvider {
  @override
  FutureOr<Credentials> fetch() {
    return Credentials(getProperty("MINIO_ACCESS_KEY")!,
        getProperty("MINIO_SECRET_KEY")!, null, null);
  }
}
