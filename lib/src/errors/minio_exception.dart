library minio_exception;

import 'package:http/http.dart';
import 'package:minio_flutter/src/messages/error_response.dart';

part 'bucket_policy_too_large_exception.dart';
part 'error_response_exception.dart';
part 'insufficient_data_exception.dart';
part 'internal_exception.dart';
part 'invalid_response_exception.dart';
part 'server_exception.dart';
part 'xml_parser_exception.dart';

class MinioException implements Exception {
  String? message;
  String? httpTrace;

  /// Constructs a new MinioException.
  MinioException([this.message, this.httpTrace]);

  @override
  String toString() {
    if (message == null) {
      return "MinioException";
    }
    return "MinioException: $message ${httpTrace ?? ""}";
  }
}
