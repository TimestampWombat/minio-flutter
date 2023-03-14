import 'package:json_annotation/json_annotation.dart';

part 'error_response.g.dart';

@JsonSerializable(fieldRename: FieldRename.pascal)
class ErrorResponse {
  final String? code;
  final String? message;
  final String? bucketName;
  @JsonKey(name: 'Key')
  final String? objectName;
  final String? resource;
  final String? requestId;
  final String? hostId;

  ErrorResponse({
    this.code,
    this.message,
    this.bucketName,
    this.objectName,
    this.resource,
    this.requestId,
    this.hostId,
  });

  factory ErrorResponse.fromJson(Map<String, dynamic> json) =>
      _$ErrorResponseFromJson(json);
  Map<String, dynamic> toJson() => _$ErrorResponseToJson(this);
}
