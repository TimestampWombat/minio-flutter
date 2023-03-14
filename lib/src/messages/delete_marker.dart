// @Root(name = "DeleteMarker", strict = false)

import 'package:json_annotation/json_annotation.dart';

import 'item.dart';
import 'owner.dart';
import 'response_date.dart';

part 'delete_marker.g.dart';
@JsonSerializable()
class DeleteMarker extends Item {
  DeleteMarker(
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

  DeleteMarker.prefix(String prefix) : super.prefix(prefix);

  factory DeleteMarker.fromJson(Map<String, dynamic> json) =>
      _$DeleteMarkerFromJson(json);

  Map<String, dynamic> toJson() => _$DeleteMarkerToJson(this);
}
