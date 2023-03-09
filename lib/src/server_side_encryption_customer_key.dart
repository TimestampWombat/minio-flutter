import 'dart:collection';
import 'dart:convert';
import 'dart:io';

import 'package:crypto/crypto.dart';
import 'package:cryptography/cryptography.dart';

import 'server_side_encryption.dart';

/// Customer-key type of Server-side encryption.
class ServerSideEncryptionCustomerKey extends ServerSideEncryption {
  bool isDestroyed = false;
  late final SecretKey secretKey;
  late final Map<String, String> _headers;
  late final Map<String, String> _copySourceHeaders;

  ServerSideEncryptionCustomerKey(SecretKeyData? key) {
    if (key == null ||
        // !key.getAlgorithm().equals("AES") ||
        key.bytes.length != 32) {
      throw ArgumentError("Secret key must be 256 bit AES key");
    }

    if (key.isDestroyed) {
      throw ArgumentError("Secret key already destroyed");
    }

    secretKey = key;

    List<int> keyBytes = key.bytes;
    Digest digest = md5.convert(keyBytes);

    String customerKey = base64.encode(keyBytes);
    String customerKeyMd5 = base64.encode(digest.bytes);

    Map<String, String> map = <String, String>{};
    map.addAll({
      "X-Amz-Server-Side-Encryption-Customer-Algorithm": "AES256",
      "X-Amz-Server-Side-Encryption-Customer-Key": customerKey,
      "X-Amz-Server-Side-Encryption-Customer-Key-Md5": customerKeyMd5
    });
    _headers = UnmodifiableMapView(map);

    map = <String, String>{};
    map.addAll({
      "X-Amz-Copy-Source-Server-Side-Encryption-Customer-Algorithm": "AES256",
      "X-Amz-Copy-Source-Server-Side-Encryption-Customer-Key": customerKey,
      "X-Amz-Copy-Source-Server-Side-Encryption-Customer-Key-Md5":
          customerKeyMd5
    });
    _copySourceHeaders = UnmodifiableMapView(map);
  }

  @override
  Map<String, String> headers() {
    if (isDestroyed) {
      throw StateError("Secret key was destroyed");
    }

    return _headers;
  }

  @override
  Map<String, String> copySourceHeaders() {
    if (isDestroyed) {
      throw StateError("Secret key was destroyed");
    }

    return _copySourceHeaders;
  }

  void destroy() {
    secretKey.destroy();
    isDestroyed = true;
  }

  @override
  String toString() {
    return "SSE-C";
  }
}
