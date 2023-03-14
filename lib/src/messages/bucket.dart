import 'package:json_annotation/json_annotation.dart';

import 'package:minio_flutter/src/messages/response_date.dart';

part 'bucket.g.dart';

/// Helper class to denote bucket information for {@link ListAllMyBucketsResult}.
@JsonSerializable(fieldRename: FieldRename.pascal)
class Bucket {
  final String name;

  @JsonKey(fromJson: ResponseDate.fromJson, toJson: ResponseDate.toJson)
  final ResponseDate creationDate;

  Bucket(this.name, this.creationDate);

  factory Bucket.fromJson(Map<String, dynamic> json) => _$BucketFromJson(json);

  Map<String, dynamic> toJson() => _$BucketToJson(this);
}
