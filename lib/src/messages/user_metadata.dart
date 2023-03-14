// @Root(name = "UserMetadata", strict = false)
// @Namespace(reference = "http://s3.amazonaws.com/doc/2006-03-01/")
// @edu.umd.cs.findbugs.annotations.SuppressFBWarnings(value = "URF_UNREAD_FIELD")

import 'dart:collection';

import 'package:json_annotation/json_annotation.dart';

part 'user_metadata.g.dart';

@JsonSerializable()
class UserMetadata {
  // @ElementMap(
  //     attribute = false,
  //     entry = "MetadataEntry",
  //     inline = true,
  //     key = "Name",
  //     value = "Value",
  //     required = false)
  @JsonKey(name: "MetadataEntry")
  late final Map<String, String> metadataEntries;

  UserMetadata(Map<String, String> metadataEntries) {
    if (metadataEntries.isEmpty) {
      throw ArgumentError("Metadata entries must not be empty");
    }
    this.metadataEntries = UnmodifiableMapView(metadataEntries);
  }

  factory UserMetadata.fromJson(Map<String, dynamic> json) =>
      _$UserMetadataFromJson(json);
}
