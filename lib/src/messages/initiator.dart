// @Root(name = "Initiator", strict = false)

import 'package:json_annotation/json_annotation.dart';

@JsonSerializable(fieldRename: FieldRename.pascal)
class Initiator {
  @JsonKey(name: "ID")
  final String? id;

  final String? displayName;

  Initiator(this.id, this.displayName);

  factory Initiator.fromJson(Map<String, dynamic> json) =>
      _$InitiatorFromJson(json);
  Map<String, dynamic> toJson() => _$InitiatorToJson(this);
}
