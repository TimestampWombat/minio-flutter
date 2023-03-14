// @Root(name = "AbortIncompleteMultipartUpload")

import 'package:json_annotation/json_annotation.dart';

part 'abort_incomplete_multipart_upload.g.dart';
@JsonSerializable(fieldRename: FieldRename.pascal)
class AbortIncompleteMultipartUpload {
  @JsonKey(name: "DaysAfterInitiation")
  int daysAfterInitiation;

  AbortIncompleteMultipartUpload(this.daysAfterInitiation);

  factory AbortIncompleteMultipartUpload.fromJson(Map<String, dynamic> json) =>
      _$AbortIncompleteMultipartUploadFromJson(json);
  Map<String, dynamic> toJson() => _$AbortIncompleteMultipartUploadToJson(this);
}
