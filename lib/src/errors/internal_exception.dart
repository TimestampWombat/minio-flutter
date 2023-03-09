part of minio_exception;

class InternalException extends MinioException {
  InternalException(super.message, super.httpTrace);
}
