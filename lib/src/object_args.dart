import 'package:collection/collection.dart';

import 'bucket_args.dart' as BucketArgs;
import 'server_side_encryption.dart';

/// Base argument class holds object name and version ID along with bucket information.
abstract class ObjectArgs extends BucketArgs.BucketArgs {
  late String objectName;

  String object() {
    return objectName;
  }

  void checkSse(ServerSideEncryption? sse, Uri url) {
    if (sse == null) {
      return;
    }

    if (sse.tlsRequired() && !url.scheme.startsWith("https")) {
      throw ArgumentError(
          "$sse operations must be performed over a secure connection.");
    }
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    if (other is! ObjectArgs) return false;

    if (super != other) return false;
    return objectName == other.objectName;
  }

  @override
  int get hashCode {
    return ListEquality().hash([super.hashCode, objectName]);
  }
}

/// Base argument builder class for {@link ObjectArgs}.
abstract class Builder<B extends Builder<B, A>, A extends ObjectArgs>
    extends BucketArgs.Builder<B, A> {
  void validateObjectName(String name) {
    validateNotEmptyString(name, "object name");
    for (String token in name.split("/")) {
      if (token == "." || token == "..") {
        throw ArgumentError(
            "object name with '.' or '..' path segment is not supported");
      }
    }
  }

  @override
  void validate(A args) {
    super.validate(args);
    validateObjectName(args.objectName);
  }

  B object(String name) {
    validateObjectName(name);
    operations.add((args) => args.objectName = name);
    return this as B;
  }
}
