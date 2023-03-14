// @Root(name = "Owner", strict = false)

import 'package:json_annotation/json_annotation.dart';

part 'owner.g.dart';

@JsonSerializable(fieldRename: FieldRename.pascal)
class Owner {
  @JsonKey(name: "ID")
  final String? id;

  final String? displayName;

  Owner(this.id, this.displayName);

  factory Owner.fromJson(Map<String, dynamic> json) => _$OwnerFromJson(json);
  Map<String, dynamic> toJson() => _$OwnerToJson(this);
}
