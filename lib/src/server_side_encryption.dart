import 'dart:collection';

abstract class ServerSideEncryption {
  static final Map<String, String> emptyHeaders =
      UnmodifiableMapView(<String, String>{});

  Map<String, String> headers();

  bool tlsRequired() {
    return true;
  }

  Map<String, String> copySourceHeaders() {
    return emptyHeaders;
  }
}
