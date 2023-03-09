import 'package:collection/collection.dart';

import 'object_args.dart' as ObjectArgs;

/// Base argument class holds object name and version ID along with bucket information.
abstract class ObjectVersionArgs extends ObjectArgs.ObjectArgs {
  String? versionId;

  @override
  bool operator ==(Object other) {
    if (this == other) return true;
    if (other is! ObjectVersionArgs) return false;
    if (super != other) return false;
    return versionId == other.versionId;
  }

  @override
  int get hashCode {
    return ListEquality().hash([super.hashCode, versionId]);
  }
}

/// Base argument builder class for {@link ObjectVersionArgs}.
abstract class Builder<B extends Builder<B, A>, A extends ObjectVersionArgs>
    extends ObjectArgs.Builder<B, A> {
  B versionId(String versionId) {
    operations.add((args) => args.versionId = versionId);
    return this as B;
  }
}
