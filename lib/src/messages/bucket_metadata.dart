import 'package:json_annotation/json_annotation.dart';

import 'identity.dart';

part 'bucket_metadata.g.dart';

/// Helper class to denote bucket information for {@link EventMetadata}.
// @edu.umd.cs.findbugs.annotations.SuppressFBWarnings(
//     value = "UwF",
//     justification = "Everything in this class is initialized by JSON unmarshalling.")
@JsonSerializable()
class BucketMetadata {
  final String name;
  final Identity? ownerIdentity;
  final String? arn;

  String? owner() {
    return ownerIdentity?.principalId;
  }

  BucketMetadata(this.name, this.ownerIdentity, this.arn);

  factory BucketMetadata.fromJson(Map<String, dynamic> json) =>
      _$BucketMetadataFromJson(json);

  Map<String, dynamic> toJson() => _$BucketMetadataToJson(this);
}
