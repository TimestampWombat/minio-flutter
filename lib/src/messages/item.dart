import 'dart:collection';

import 'package:json_annotation/json_annotation.dart';

import '../errors/minio_exception.dart';
import 'delete_marker.dart';
import 'owner.dart';
import 'response_date.dart';

part 'item.g.dart';

@JsonSerializable(fieldRename: FieldRename.pascal)
class Item {
  final String? etag; // except DeleteMarker

  @JsonKey(name: "Key")
  final String objectNameK;

  @JsonKey(fromJson: ResponseDate.fromJson, toJson: ResponseDate.toJson)
  final ResponseDate? lastModified;

  final Owner? owner;

  final int? size; // except DeleteMarker

  final String?
      storageClass; // except DeleteMarker, not in case of MinIO server.

  final bool? isLatest; // except ListObjects V1

  final String? versionId; // except ListObjects V1

  @JsonKey(name: "UserMetadata")
  final Map<String, String>? userMetadataK;

  @JsonKey(includeFromJson: false)
  bool isDir = false;
  @JsonKey(includeFromJson: false)
  String? encodingType;

  Item(this.etag, this.objectNameK, this.lastModified, this.owner, this.size,
      this.storageClass, this.isLatest, this.versionId, this.userMetadataK,
      {this.isDir = false, this.encodingType});

  /// Constructs a Item for prefix i.e. directory.
  Item.prefix(String objectNameK)
      : this(null, objectNameK, null, null, null, null, null, null, null,
            isDir: true);

  /// Returns object name.
  String objectName() {
    try {
      return "url" == encodingType ? Uri.decodeFull(objectNameK) : objectNameK;
    } catch (e) {
      throw RuntimeException('$e');
    }
  }

  /// Returns user metadata. This is MinIO specific extension to ListObjectsV2.
  Map<String, String> userMetadata() {
    return UnmodifiableMapView(userMetadataK ?? HashMap());
  }

  bool isDeleteMarker() {
    return this is DeleteMarker;
  }

  factory Item.fromJson(Map<String, dynamic> json) => _$ItemFromJson(json);
  Map<String, dynamic> toJson() => _$ItemToJson(this);
}
