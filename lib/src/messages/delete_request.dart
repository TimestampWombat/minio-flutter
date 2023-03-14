// @Root(name = "Delete")
// @Namespace(reference = "http://s3.amazonaws.com/doc/2006-03-01/")
// @edu.umd.cs.findbugs.annotations.SuppressFBWarnings(value = "URF_UNREAD_FIELD")

import 'dart:collection';

import 'package:json_annotation/json_annotation.dart';

import 'delete_object.dart';

part 'delete_request.g.dart';

@JsonSerializable(fieldRename: FieldRename.pascal)
class DeleteRequest {
  final bool quiet;

  @JsonKey(name: "Object")
  final List<DeleteObject> objectList;

  /// Constructs delete request for given object list and quiet flag.
  DeleteRequest(List<DeleteObject> objectList, this.quiet)
      : objectList = UnmodifiableListView(objectList);

  factory DeleteRequest.fromJson(Map<String, dynamic> json) =>
      _$DeleteRequestFromJson(json);

  Map<String, dynamic> toJson() => _$DeleteRequestToJson(this);
}
