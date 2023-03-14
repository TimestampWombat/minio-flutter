// @Root(name = "CopyObjectResult", strict = false)
// @Namespace(reference = "http://s3.amazonaws.com/doc/2006-03-01/")

import 'package:json_annotation/json_annotation.dart';

import 'response_date.dart';

part 'copy_object_result.g.dart';

@JsonSerializable(fieldRename: FieldRename.pascal)
class CopyObjectResult {
  @JsonKey(name: "ETag")
  final String etag;

  @JsonKey(fromJson: ResponseDate.fromJson, toJson: ResponseDate.toJson)
  final ResponseDate lastModified;

  CopyObjectResult(this.etag, this.lastModified);

  factory CopyObjectResult.fromJson(Map<String, dynamic> json) =>
      _$CopyObjectResultFromJson(json);

  Map<String, dynamic> toJson() => _$CopyObjectResultToJson(this);
}
