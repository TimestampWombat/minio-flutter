// @Root(name = "DeleteResult", strict = false)
// @Namespace(reference = "http://s3.amazonaws.com/doc/2006-03-01/")
import 'dart:collection';

import 'package:json_annotation/json_annotation.dart';

import 'delete_error.dart';
import 'deleted_object.dart';

part 'delete_result.g.dart';

@JsonSerializable(fieldRename: FieldRename.pascal)
class DeleteResult {
  @JsonKey(name: "Deleted")
  final List<DeletedObject>? objectListK;

  @JsonKey(name: "Error")
  late final List<DeleteError>? errorListK;

  DeleteResult(this.objectListK, this.errorListK);

  /// Constructs delete result with an error.
  DeleteResult.error(DeleteError error) : this(null, [error]);

  /// Returns deleted object list.
  List<DeletedObject> objectList() {
    return UnmodifiableListView(objectListK ?? []);
  }

  /// Returns delete error list.
  List<DeleteError> errorList() {
    return UnmodifiableListView(errorListK ?? []);
  }

  factory DeleteResult.fromJson(Map<String, dynamic> json) =>
      _$DeleteResultFromJson(json);

  Map<String, dynamic> toJson() => _$DeleteResultToJson(this);
}
