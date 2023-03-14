// @Root(name = "Part", strict = false)

import 'package:json_annotation/json_annotation.dart';

import 'response_date.dart';

part 'part.g.dart';

@JsonSerializable(fieldRename: FieldRename.pascal)
class Part {
  final int partNumber;

  @JsonKey(name: "ETag")
  final String etagK;

  @JsonKey(fromJson: ResponseDate.fromJson, toJson: ResponseDate.toJson)
  final ResponseDate? lastModified;

  final int size;

  Part(this.partNumber, this.etagK, [this.lastModified, this.size = 0]);

  /// Returns ETag.
  String etag() {
    return etagK.replaceAll("\"", "");
  }

  factory Part.fromJson(Map<String, dynamic> json) => _$PartFromJson(json);
  Map<String, dynamic> toJson() => _$PartToJson(this);
}
