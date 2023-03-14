// @Root(name = "NoncurrentVersionTransition")
import 'package:json_annotation/json_annotation.dart';

import 'noncurrent_version_expiration.dart';

part 'noncurrent_version_transition.g.dart';

@JsonSerializable(fieldRename: FieldRename.pascal)
class NoncurrentVersionTransition extends NoncurrentVersionExpiration {
  // @Element(name = "StorageClass")
  final String storageClass;

  NoncurrentVersionTransition(super.noncurrentDays, this.storageClass) {
    if (storageClass.isEmpty) {
      throw ArgumentError("StorageClass must be provided");
    }
  }

  factory NoncurrentVersionTransition.fromJson(Map<String, dynamic> json) =>
      _$NoncurrentVersionTransitionFromJson(json);

  Map<String, dynamic> toJson() => _$NoncurrentVersionTransitionToJson(this);
}
