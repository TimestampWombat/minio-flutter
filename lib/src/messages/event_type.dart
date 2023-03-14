// @Root(name = "Event")
// @Convert(EventType.EventTypeConverter.class)

import 'package:json_annotation/json_annotation.dart';

enum EventType {
  @JsonValue("s3:ObjectCreated:*")
  OBJECT_CREATED_ANY,
  @JsonValue("s3:ObjectCreated:Put")
  OBJECT_CREATED_PUT,
  @JsonValue("s3:ObjectCreated:Post")
  OBJECT_CREATED_POST,
  @JsonValue("s3:ObjectCreated:Copy")
  OBJECT_CREATED_COPY,
  @JsonValue("s3:ObjectCreated:CompleteMultipartUpload")
  OBJECT_CREATED_COMPLETE_MULTIPART_UPLOAD,
  @JsonValue("s3:ObjectAccessed:Get")
  OBJECT_ACCESSED_GET,
  @JsonValue("s3:ObjectAccessed:Head")
  OBJECT_ACCESSED_HEAD,
  @JsonValue("s3:ObjectAccessed:*")
  OBJECT_ACCESSED_ANY,
  @JsonValue("s3:ObjectRemoved:*")
  OBJECT_REMOVED_ANY,
  @JsonValue("s3:ObjectRemoved:Delete")
  OBJECT_REMOVED_DELETE,
  @JsonValue("s3:ObjectRemoved:DeleteMarkerCreated")
  OBJECT_REMOVED_DELETED_MARKER_CREATED,
  @JsonValue("s3:ReducedRedundancyLostObject")
  REDUCED_REDUNDANCY_LOST_OBJECT,
  @JsonValue("s3:BucketCreated")
  BUCKET_CREATED,
  @JsonValue("s3:BucketRemoved")
  BUCKET_REMOVED,
}
