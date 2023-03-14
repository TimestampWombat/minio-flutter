// @Root(name = "CommonPrefixes", strict = false)

import 'package:json_annotation/json_annotation.dart';

import 'contents.dart';
import 'item.dart';

part 'prefix.g.dart';

@JsonSerializable(fieldRename: FieldRename.pascal)
class Prefix {
  @JsonKey(name: "Prefix")
  final String prefix;

  Prefix(this.prefix);

  Item toItem() {
    return Contents(prefix);
  }

  factory Prefix.fromJson(Map<String, dynamic> json) => _$PrefixFromJson(json);

  Map<String, dynamic> toJson() => _$PrefixToJson(this);
}
