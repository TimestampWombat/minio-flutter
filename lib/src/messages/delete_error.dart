// @Root(name = "Error", strict = false)
// @Namespace(reference = "http://s3.amazonaws.com/doc/2006-03-01/")
import 'package:json_annotation/json_annotation.dart';

import 'error_response.dart';

part 'delete_error.g.dart';
@JsonSerializable()
class DeleteError extends ErrorResponse {
  DeleteError(
      {super.code,
      super.message,
      super.bucketName,
      super.objectName,
      super.resource,
      super.requestId,
      super.hostId});

  factory DeleteError.fromJson(Map<String, dynamic> json) =>
      _$DeleteErrorFromJson(json);

  Map<String, dynamic> toJson() => _$DeleteErrorToJson(this);
}
