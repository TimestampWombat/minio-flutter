part of minio_exception;

class XmlParserException extends MinioException {
  XmlParserException(Exception e) : super(e.toString());
}
