// @edu.umd.cs.findbugs.annotations.SuppressFBWarnings(
//     value = {"UwF", "UuF"},
//     justification =
//         "Everything in this class is initialized by JSON unmarshalling "
//             + "and s3SchemaVersion/configurationId are available for completeness.")

import 'package:json_annotation/json_annotation.dart';

import 'bucket_metadata.dart';
import 'object_metadata.dart';

part 'event_metadata.g.dart';

@JsonSerializable()
class EventMetadata {
  final String? s3SchemaVersion;
  final String? configurationId;
  final BucketMetadata? bucket;
  final ObjectMetadata? object;

  EventMetadata(
      this.s3SchemaVersion, this.configurationId, this.bucket, this.object);

  String? bucketName() {
    return bucket?.name;
  }

  String? bucketOwner() {
    return bucket?.owner();
  }

  String? bucketArn() {
    return bucket?.arn;
  }

  String? objectName() {
    return object?.key;
  }

  int objectSize() {
    return object?.size ?? -1;
  }

  String? etag() {
    return object?.eTag;
  }

  String? objectVersionId() {
    return object?.versionId;
  }

  String? sequencer() {
    return object?.sequencer;
  }

  Map<String, String>? userMetadata() {
    return object?.userMetadata();
  }

  factory EventMetadata.fromJson(Map<String, dynamic> json) =>
      _$EventMetadataFromJson(json);

  Map<String, dynamic> toJson() => _$EventMetadataToJson(this);
}
