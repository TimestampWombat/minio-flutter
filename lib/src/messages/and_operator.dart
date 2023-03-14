// @Root(name = "And")

import 'dart:collection';

import 'package:json_annotation/json_annotation.dart';

part 'and_operator.g.dart';

@JsonSerializable(fieldRename: FieldRename.pascal)
class AndOperator {
  // @Element(name = "Prefix", required = false)
  // @Convert(PrefixConverter.class)
  late final String? prefix;

  // @ElementMap(
  //     attribute = false,
  //     entry = "Tag",
  //     inline = true,
  //     key = "Key",
  //     value = "Value",
  //     required = false)

  late final Map<String, String>? tags;

  AndOperator(this.prefix, Map<String, String>? tags) {
    if (prefix == null && tags == null) {
      throw ArgumentError("At least Prefix or Tags must be set");
    }

    if (tags != null) {
      for (String key in tags.keys) {
        if (key.isEmpty) {
          throw ArgumentError("Tags must not contain empty key");
        }
      }
    }
    this.tags = (tags != null) ? UnmodifiableMapView(tags) : null;
  }

  factory AndOperator.fromJson(Map<String, dynamic> json) =>
      _$AndOperatorFromJson(json);

  Map<String, dynamic> toJson() => _$AndOperatorToJson(this);
}
