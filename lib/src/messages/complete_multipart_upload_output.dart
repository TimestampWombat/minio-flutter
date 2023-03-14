// @Root(name = "CompleteMultipartUploadOutput")
// @Namespace(reference = "http://s3.amazonaws.com/doc/2006-03-01/")

import 'package:json_annotation/json_annotation.dart';

part 'complete_multipart_upload_output.g.dart';

@JsonSerializable(fieldRename: FieldRename.pascal)
class CompleteMultipartUploadOutput {
  final String location;

  final String bucket;

  @JsonKey(name: "Key")
  final String object;

  final String etag;

  final String? checksumCRC32;

  final String? checksumCRC32C;

  final String? checksumSHA1;

  final String? checksumSHA256;

  CompleteMultipartUploadOutput({
    required this.location,
    required this.bucket,
    required this.object,
    required this.etag,
    this.checksumCRC32,
    this.checksumCRC32C,
    this.checksumSHA1,
    this.checksumSHA256,
  });

  factory CompleteMultipartUploadOutput.fromJson(Map<String, dynamic> json) =>
      _$CompleteMultipartUploadOutputFromJson(json);

  Map<String, dynamic> toJson() => _$CompleteMultipartUploadOutputToJson(this);
}
