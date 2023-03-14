// @Root(name = "AccessControlTranslation")

import 'package:json_annotation/json_annotation.dart';

part 'access_control_translation.g.dart';

@JsonSerializable(fieldRename: FieldRename.pascal)
class AccessControlTranslation {
  final String owner;

  AccessControlTranslation([this.owner = "Destination"]);

  factory AccessControlTranslation.fromJson(Map<String, dynamic> json) =>
      _$AccessControlTranslationFromJson(json);

  Map<String, dynamic> toJson() => _$AccessControlTranslationToJson(this);
}
