// @Root(name = "CompleteMultipartUpload")
// @Namespace(reference = "http://s3.amazonaws.com/doc/2006-03-01/")
// @edu.umd.cs.findbugs.annotations.SuppressFBWarnings(value = "URF_UNREAD_FIELD")

import 'dart:collection';

import 'package:json_annotation/json_annotation.dart';

import 'part.dart';

part 'complete_multipart_upload.g.dart';

@JsonSerializable()
class CompleteMultipartUpload {
  @JsonKey(name: "Part")
  late final List<Part> partList;

  CompleteMultipartUpload(this.partList);

  /// Constucts a CompleteMultipartUpload object with given parts.
  CompleteMultipartUpload.parts(List<Part> parts) {
    if (parts.isEmpty) {
      throw ArgumentError("null or empty parts");
    }

    partList = UnmodifiableListView(parts);
  }

  factory CompleteMultipartUpload.fromJson(Map<String, dynamic> json) =>
      _$CompleteMultipartUploadFromJson(json);

  Map<String, dynamic> toJson() => _$CompleteMultipartUploadToJson(this);
}
