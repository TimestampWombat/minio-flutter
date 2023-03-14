// @Root(name = "Grantee")
// @edu.umd.cs.findbugs.annotations.SuppressFBWarnings(value = "URF_UNREAD_FIELD")

import 'package:json_annotation/json_annotation.dart';

import 'grantee_type.dart';

part 'grantee.g.dart';
@JsonSerializable(fieldRename: FieldRename.pascal)
class Grantee {
  // @Element(name = "DisplayName", required = false)
  String? displayName;

  // @Element(name = "EmailAddress", required = false)
  String? emailAddress;

  @JsonKey(name: "ID")
  String? id;

  // @Element(name = "Type")
  final GranteeType type;

  @JsonKey(name: "URI")
  String? uri;

  Grantee({
    this.displayName,
    this.emailAddress,
    this.id,
    required this.type,
    this.uri,
  });

  factory Grantee.fromJson(Map<String, dynamic> json) =>
      _$GranteeFromJson(json);

  Map<String, dynamic> toJson() => _$GranteeToJson(this);
}
