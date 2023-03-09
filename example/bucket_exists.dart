import 'package:collection/collection.dart';
import 'package:minio_flutter/src/bucket_exists_args.dart';
import 'package:minio_flutter/src/errors/minio_exception.dart';
import 'package:minio_flutter/src/utils/multimapx.dart';
import 'package:quiver/collection.dart';

void main() {
  try {
    /* play.min.io for test and development. */
    MinioClient minioClient = MinioClient.builder()
        .endpoint("https://play.min.io")
        .credentials(
            "Q3AM3UQ867SPQQA43P2F", "zuf+tfteSlswRu7BJ86wekitnifILbZam1KYY3TG")
        .build();

    /* Amazon S3: */
    // MinioClient minioClient =
    //     MinioClient.builder()
    //         .endpoint("https://s3.amazonaws.com")
    //         .credentials("YOUR-ACCESSKEY", "YOUR-SECRETACCESSKEY")
    //         .build();

    // Check whether 'my-bucketname' exist or not.
    bool found = minioClient.bucketExists(
        BucketExistsArgs.builder().bucket("my-bucketname").build());
    if (found) {
      print("my-bucketname exists");
    } else {
      print("my-bucketname does not exist");
    }
  } on MinioException catch (e) {
    print("Error occurred: $e");
  }
}
