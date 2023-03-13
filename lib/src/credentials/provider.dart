import 'dart:async';

import 'credentials.dart';

abstract class Provider {
  FutureOr<Credentials> fetch();
}
