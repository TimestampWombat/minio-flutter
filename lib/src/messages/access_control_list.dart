// @Root(name = "AccessControlList")
// @edu.umd.cs.findbugs.annotations.SuppressFBWarnings(value = "URF_UNREAD_FIELD")

import 'dart:collection';

import 'package:json_annotation/json_annotation.dart';

import 'grant.dart';

part 'access_control_list.g.dart';
@JsonSerializable()
class AccessControlList {
  @JsonKey(name: "Grant")
  late final List<Grant> grants;

  AccessControlList(List<Grant> grants) {
    if (grants.isEmpty) {
      throw ArgumentError("Grants must not be empty");
    }
    this.grants = UnmodifiableListView(grants);
  }

  factory AccessControlList.fromJson(Map<String, dynamic> json) =>
      _$AccessControlListFromJson(json);

  Map<String, dynamic> toJson() => _$AccessControlListToJson(this);
}
