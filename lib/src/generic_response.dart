import 'dart:io';

/// Generic response class of any APIs.
class GenericResponse {
  final HttpHeaders headers;
  final String bucket;
  final String region;
  final String object;

  GenericResponse(this.headers, this.bucket, this.region, this.object);
}
