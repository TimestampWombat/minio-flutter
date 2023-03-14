// @Root(name = "Object")
// @edu.umd.cs.findbugs.annotations.SuppressFBWarnings(value = "URF_UNREAD_FIELD")

import 'package:json_annotation/json_annotation.dart';

part 'delete_object.g.dart';

@JsonSerializable(fieldRename: FieldRename.pascal)
class DeleteObject {
  @JsonKey(name: "Key")
  final String name;

  final String? versionId;

  DeleteObject(this.name, [this.versionId]);

  factory DeleteObject.fromJson(Map<String, dynamic> json) =>
      _$DeleteObjectFromJson(json);

  Map<String, dynamic> toJson() => _$DeleteObjectToJson(this);
}
