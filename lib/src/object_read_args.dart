import 'package:collection/collection.dart';

import 'object_version_args.dart' as ObjectVersionArgs;
import 'server_side_encryption_customer_key.dart';

/// Base argument class for reading object.
abstract class ObjectReadArgs extends ObjectVersionArgs.ObjectVersionArgs {
  ServerSideEncryptionCustomerKey? ssec;

  void validateSsec(Uri url) {
    checkSse(ssec, url);
  }

  @override
  bool operator ==(Object other) {
    if (this == other) return true;
    if (other is! ObjectReadArgs) return false;
    if (super != other) return false;
    return ssec == other.ssec;
  }

  @override
  int get hashCode {
    return ListEquality().hash([super.hashCode, ssec]);
  }
}

/// Base argument builder class for {@link ObjectReadArgs}.
abstract class Builder<B extends Builder<B, A>, A extends ObjectReadArgs>
    extends ObjectVersionArgs.Builder<B, A> {
  // Its safe to type cast to B as B is inherited by this class
  B ssec(ServerSideEncryptionCustomerKey ssec) {
    operations.add((args) => args.ssec = ssec);
    return this as B;
  }
}
