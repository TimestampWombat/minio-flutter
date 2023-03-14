// @Root(name = "SseKmsEncryptedObjects")
import 'package:json_annotation/json_annotation.dart';

import 'status.dart';

part 'sse_kms_encrypted_objects.g.dart';

@JsonSerializable(fieldRename: FieldRename.pascal)
class SseKmsEncryptedObjects {
  // @Element(name = "Status")
  final Status status;

  SseKmsEncryptedObjects(this.status);

  factory SseKmsEncryptedObjects.fromJson(Map<String, dynamic> json) =>
      _$SseKmsEncryptedObjectsFromJson(json);

  Map<String, dynamic> toJson() => _$SseKmsEncryptedObjectsToJson(this);
}
