// @Root(name = "FilterRule", strict = false)

import 'package:json_annotation/json_annotation.dart';

part 'filter_rule.g.dart';

@JsonSerializable(fieldRename: FieldRename.pascal)
class FilterRule {
  final String name;

  final String value;

  FilterRule(this.name, this.value);

  factory FilterRule.fromJson(Map<String, dynamic> json) =>
      _$FilterRuleFromJson(json);

  Map<String, dynamic> toJson() => _$FilterRuleToJson(this);
}
