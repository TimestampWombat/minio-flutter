part of minio_exception;

class ErrorResponseException extends MinioException {
  final ErrorResponse errorResponse;

  final Response response;

  /// Constructs a ErrorResponseException with error response and HTTP response object.
  ErrorResponseException(this.errorResponse, this.response, String httpTrace)
      : super(errorResponse.message, httpTrace);

  @override
  String toString() {
    BaseRequest request = response.request!;
    StringBuffer buffer = StringBuffer();
    buffer
      ..writeln('error occurred')
      ..writeln(errorResponse.toString())
      ..write('request={')
      ..write('method=')
      ..write(request.method)
      ..write(', ')
      ..write('url=')
      ..write(request.url)
      ..write(', ')
      ..write('headers=')
      ..write(request.headers
          .toString()
          .replaceAll('Signature=([0-9a-f]+)', 'Signature=*REDACTED*')
          .replaceAll("Credential=([^/]+)", "Credential=*REDACTED*"))
      ..writeln('}')
      ..write('response={')
      ..write('code=')
      ..write(response.statusCode)
      ..write(', ')
      ..write('headers=')
      ..write(response.headers)
      ..writeln('}');
    return buffer.toString();
  }
}
