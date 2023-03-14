// @Root(name = "Version", strict = false)

import 'package:json_annotation/json_annotation.dart';

import 'item.dart';

part 'version.g.dart';

@JsonSerializable(fieldRename: FieldRename.pascal)
class Version extends Item {

  Version.prefix(String prefix) : super.prefix(prefix);

  factory Version.fromJson(Map<String, dynamic> json) =>
      _$VersionFromJson(json);

  Map<String, dynamic> toJson() => _$VersionToJson(super);
}
