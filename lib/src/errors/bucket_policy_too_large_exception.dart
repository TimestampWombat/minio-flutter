part of minio_exception;

class BucketPolicyTooLargeException extends MinioException {
  BucketPolicyTooLargeException(String bucketName)
      : super("Bucket policy is larger than 20KiB size for bucket $bucketName");
}
