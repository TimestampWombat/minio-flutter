// @Root(name = "Grant")
// @edu.umd.cs.findbugs.annotations.SuppressFBWarnings(value = "URF_UNREAD_FIELD")

import 'package:json_annotation/json_annotation.dart';

import 'grantee.dart';
import 'permission.dart';

part 'grant.g.dart';

@JsonSerializable(fieldRename: FieldRename.pascal)
class Grant {
  // @Element(name = "Grantee", required = false)
  final Grantee? grantee;

  // @Element(name = "Permission", required = false)
  final Permission? permission;

  Grant(this.grantee, this.permission) {
    if (grantee == null && permission == null) {
      throw ArgumentError("Either Grantee or Permission must be provided");
    }
  }

  factory Grant.fromJson(Map<String, dynamic> json) => _$GrantFromJson(json);

  Map<String, dynamic> toJson() => _$GrantToJson(this);
}
