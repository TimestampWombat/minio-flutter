part of minio_exception;

class RuntimeException extends MinioException {
  RuntimeException([super.message, super.httpTrace]);
}
