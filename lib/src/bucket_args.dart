import 'package:collection/collection.dart';

import 'base_args.dart' as BaseArgs;

/// Base argument class holds bucket name and region.
abstract class BucketArgs extends BaseArgs.BaseArgs {
  late String bucketName;
  late String region;

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    if (other is! BucketArgs) return false;
    if (super != other) return false;
    return bucketName == other.bucketName && region == other.region;
  }

  @override
  int get hashCode {
    return ListEquality().hash([super.hashCode, bucketName, region]);
  }
}

/// Base argument builder class for {@link BucketArgs}.
abstract class Builder<B extends Builder<B, A>, A extends BucketArgs>
    extends BaseArgs.Builder<B, A> {
  void validateBucketName(String name) {
    validateNotNull(name, "bucket name");

    // Bucket names cannot be no less than 3 and no more than 63 characters long.
    if (name.length < 3 || name.length > 63) {
      throw ArgumentError(
          "$name : bucket name must be at least 3 and no more than 63 characters long");
    }
    // Successive periods in bucket names are not allowed.
    if (name.contains("..")) {
      String msg =
          "bucket name cannot contain successive periods. For more information refer "
          "http://docs.aws.amazon.com/AmazonS3/latest/dev/BucketRestrictions.html";
      throw ArgumentError("$name : $msg");
    }
    // Bucket names should be dns compatible.
    if (RegExp(r"^[a-z0-9][a-z0-9\\.\\-]+[a-z0-9]$").stringMatch(name) ==
        null) {
      String msg =
          "bucket name does not follow Amazon S3 standards. For more information refer "
          "http://docs.aws.amazon.com/AmazonS3/latest/dev/BucketRestrictions.html";
      throw ArgumentError("$name : $msg");
    }
  }

  void validateRegion(String region) {
    validateNullOrNotEmptyString(region, "region");
  }

  @override
  void validate(A args) {
    validateBucketName(args.bucketName);
  }

  B bucket(String name) {
    validateBucketName(name);
    operations.add((args) => args.bucketName = name);
    return this as B;
  }

  B region(String region) {
    validateRegion(region);
    operations.add((args) => args.region = region);
    return this as B;
  }
}
