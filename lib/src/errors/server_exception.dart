part of minio_exception;

class ServerException extends MinioException {
  final int statusCode;
  ServerException(super.message, this.statusCode, super.httpTrace);
}
