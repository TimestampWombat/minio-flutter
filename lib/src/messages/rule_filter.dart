// @Root(name = "Filter")

import 'package:json_annotation/json_annotation.dart';

import 'package:minio_flutter/src/messages/tag.dart';
import 'and_operator.dart';

part 'rule_filter.g.dart';

@JsonSerializable(fieldRename: FieldRename.pascal)
class RuleFilter {
  @JsonKey(name: "And")
  AndOperator? andOperator;

  // @Element(name = "Prefix", required = false)
  // @Convert(PrefixConverter.class)
  String? prefix;

  Tag? tag;

  RuleFilter(AndOperator? andOperator, String? prefix, Tag? tag) {
    if ((andOperator != null) ^ (prefix != null) ^ (tag != null)) {
      this.andOperator = andOperator;
      this.prefix = prefix;
      this.tag = tag;
    } else {
      throw ArgumentError("Only one of And, Prefix or Tag must be set");
    }
  }

  RuleFilter.op(AndOperator this.andOperator);

  RuleFilter.prefix(String this.prefix);

  RuleFilter.tag(Tag this.tag);

  factory RuleFilter.fromJson(Map<String, dynamic> json) =>
      _$RuleFilterFromJson(json);

  Map<String, dynamic> toJson() => _$RuleFilterToJson(this);
}
