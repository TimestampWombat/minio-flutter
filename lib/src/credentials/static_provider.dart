import 'dart:async';

import 'credentials.dart';
import 'provider.dart';

class StaticProvider implements Provider {
  final Credentials credentials;

  StaticProvider(String accessKey, String secretKey, String? sessionToken)
      : credentials = Credentials(accessKey, secretKey, sessionToken, null);

  @override
  FutureOr<Credentials> fetch() => credentials;
}
