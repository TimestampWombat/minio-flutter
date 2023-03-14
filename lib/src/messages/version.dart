// @Root(name = "Version", strict = false)

import 'package:json_annotation/json_annotation.dart';

import 'item.dart';
import 'owner.dart';
import 'response_date.dart';

part 'version.g.dart';

@JsonSerializable(fieldRename: FieldRename.pascal)
class Version extends Item {
  Version(
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

  Version.prefix(String prefix) : super.prefix(prefix);

  factory Version.fromJson(Map<String, dynamic> json) =>
      _$VersionFromJson(json);

  Map<String, dynamic> toJson() => _$VersionToJson(super);
}
