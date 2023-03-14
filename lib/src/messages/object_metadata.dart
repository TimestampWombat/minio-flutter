import 'dart:collection';

import 'package:json_annotation/json_annotation.dart';

part 'object_metadata.g.dart';

/// Helper class to denote object information for {@link EventMetadata}.
@JsonSerializable()
class ObjectMetadata {
  final String key;
  final int size;
  final String eTag;
  final String versionId;
  final String sequencer;
  @JsonKey(name: 'userMetadata')
  final Map<String, String>? userMetadataK; // MinIO specific extension.

  ObjectMetadata(this.key, this.size, this.eTag, this.versionId, this.sequencer,
      this.userMetadataK);

  Map<String, String> userMetadata() {
    return UnmodifiableMapView(userMetadataK ?? {});
  }

  factory ObjectMetadata.fromJson(Map<String, dynamic> json) =>
      _$ObjectMetadataFromJson(json);

  Map<String, dynamic> toJson() => _$ObjectMetadataToJson(this);
}
