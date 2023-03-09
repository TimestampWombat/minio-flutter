import 'package:json_annotation/json_annotation.dart';

part 'error_response.g.dart';

@JsonSerializable(fieldRename: FieldRename.pascal)
class ErrorResponse {
  ErrorResponse({
    required this.code,
  });

  String? code;
  String? message;
  String? bucketName;
  @JsonKey(name: 'Key')
  String? objectName;
  String? resource;
  String? requestId;
  String? hostId;

  factory ErrorResponse.fromJson(Map<String, dynamic> json) =>
      _$ErrorResponseFromJson(json);
  Map<String, dynamic> toJson() => _$ErrorResponseToJson(this);
}
