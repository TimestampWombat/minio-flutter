import 'bucket_args.dart' as BucketArgs;

class BucketExistsArgs extends BucketArgs.BucketArgs {
  static Builder builder() {
    return Builder();
  }
}

/// Argument builder of {@link BucketExistsArgs}.
class Builder extends BucketArgs.Builder<Builder, BucketExistsArgs> {
  @override
  BucketExistsArgs newInstance() {
    return BucketExistsArgs();
  }
}
