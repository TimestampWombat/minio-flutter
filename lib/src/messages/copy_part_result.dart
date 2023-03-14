// @Root(name = "CopyPartResult", strict = false)
// @Namespace(reference = "http://s3.amazonaws.com/doc/2006-03-01/")

import 'package:json_annotation/json_annotation.dart';

import 'copy_object_result.dart';
import 'response_date.dart';

part 'copy_part_result.g.dart';

@JsonSerializable()
class CopyPartResult extends CopyObjectResult {
  CopyPartResult(super.etag, super.lastModified);

  factory CopyPartResult.fromJson(Map<String, dynamic> json) =>
      _$CopyPartResultFromJson(json);

  Map<String, dynamic> toJson() => _$CopyPartResultToJson(this);
}
