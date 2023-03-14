// @Root(name = "Deleted", strict = false)
import 'package:json_annotation/json_annotation.dart';

part 'deleted_object.g.dart';
@JsonSerializable(fieldRename: FieldRename.pascal)
class DeletedObject {
  @JsonKey(name: "Key")
  final String name;

  final String? versionId;

  final bool deleteMarker;

  final String? deleteMarkerVersionId;

  DeletedObject({
    required this.name,
    this.versionId,
    this.deleteMarker = false,
    this.deleteMarkerVersionId,
  });

  factory DeletedObject.fromJson(Map<String, dynamic> json) =>
      _$DeletedObjectFromJson(json);

  Map<String, dynamic> toJson() => _$DeletedObjectToJson(this);
}
