import 'object_conditional_read_args.dart' as ObjectConditionalReadArgs;
import 'object_read_args.dart';

/// Argument class of {@link MinioAsyncClient#statObject} and {@link MinioClient#statObject}.
class StatObjectArgs
    extends ObjectConditionalReadArgs.ObjectConditionalReadArgs {
  StatObjectArgs([ObjectReadArgs? args]) {
    if (args == null) {
      return;
    }

    extraHeaders = args.extraHeaders;
    extraQueryParams = args.extraQueryParams;
    bucketName = args.bucketName;
    region = args.region;
    objectName = args.objectName;
    versionId = args.versionId;
    ssec = args.ssec;
  }

  static Builder builder() {
    return Builder();
  }
}

/// Argument builder of {@link StatObjectArgs}.
class Builder
    extends ObjectConditionalReadArgs.Builder<Builder, StatObjectArgs> {
  @override
  StatObjectArgs newInstance() {
    return StatObjectArgs();
  }
}
