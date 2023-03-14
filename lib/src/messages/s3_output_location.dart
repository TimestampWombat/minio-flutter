// @Root(name = "S3OutputLocation")
// @edu.umd.cs.findbugs.annotations.SuppressFBWarnings(value = "URF_UNREAD_FIELD")

import 'package:json_annotation/json_annotation.dart';

import 'access_control_list.dart';
import 'canned_acl.dart';
import 'encryption.dart';
import 'tags.dart';
import 'user_metadata.dart';

part 's3_output_location.g.dart';

@JsonSerializable(fieldRename: FieldRename.pascal)
class S3OutputLocation {
  final AccessControlList? accessControlList;

  final String bucketName;

  final CannedAcl? cannedAcl;

  final Encryption? encryption;

  final String prefix;

  final String? storageClass;

  final Tags? tagging;

  final UserMetadata? userMetadata;
  
  S3OutputLocation({
    this.accessControlList,
    required this.bucketName,
    this.cannedAcl,
    this.encryption,
    required this.prefix,
    this.storageClass,
    this.tagging,
    this.userMetadata,
  });

  factory S3OutputLocation.fromJson(Map<String, dynamic> json) =>
      _$S3OutputLocationFromJson(json);

  Map<String, dynamic> toJson() => _$S3OutputLocationToJson(this);
}
