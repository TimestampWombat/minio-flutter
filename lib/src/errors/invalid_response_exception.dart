part of minio_exception;

class InvalidResponseException extends MinioException {
  InvalidResponseException(
      int responseCode, String contentType, String body, String httpTrace)
      : super(
            "Non-XML response from server. Response code: $responseCode, Content-Type: $contentType, body: $body",
            httpTrace);
}
