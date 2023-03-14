// @Root(name = "InitiateMultipartUploadResult", strict = false)
// @Namespace(reference = "http://s3.amazonaws.com/doc/2006-03-01/")
import 'package:json_annotation/json_annotation.dart';

part 'initiate_multipart_upload_result.g.dart';

@JsonSerializable(fieldRename: FieldRename.pascal)
class InitiateMultipartUploadResult {
  @JsonKey(name: "Bucket")
  final String bucketName;

  @JsonKey(name: "Key")
  final String objectName;

  final String uploadId;

  InitiateMultipartUploadResult(
      this.bucketName, this.objectName, this.uploadId);

  factory InitiateMultipartUploadResult.fromJson(Map<String, dynamic> json) =>
      _$InitiateMultipartUploadResultFromJson(json);

  Map<String, dynamic> toJson() => _$InitiateMultipartUploadResultToJson(this);
}
