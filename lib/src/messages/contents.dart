// @Root(name = "Contents", strict = false)

import 'package:json_annotation/json_annotation.dart';

import 'item.dart';
import 'owner.dart';
import 'response_date.dart';

part 'contents.g.dart';

@JsonSerializable()
class Contents extends Item {
  Contents(
      super.etag,
      super.objectNameK,
      super.lastModified,
      super.owner,
      super.size,
      super.storageClass,
      super.isLatest,
      super.versionId,
      super.userMetadataK,
      {super.isDir,
      super.encodingType});

  Contents.prefix(String prefix) : super.prefix(prefix);

  factory Contents.fromJson(Map<String, dynamic> json) =>
      _$ContentsFromJson(json);

  Map<String, dynamic> toJson() => _$ContentsToJson(this);
}
