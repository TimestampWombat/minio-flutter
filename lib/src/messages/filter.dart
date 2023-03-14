// @Root(name = "Filter", strict = false)

import 'dart:collection';

import 'package:json_annotation/json_annotation.dart';

import 'filter_rule.dart';

part 'filter.g.dart';

@JsonSerializable()
class Filter {
  @JsonKey(name: "S3Key")
  List<FilterRule>? _filterRuleList;

  Filter([this._filterRuleList]);

  /// Sets filter rule to list. As per Amazon AWS S3 server behavior, its not possible to set more
  /// than one rule for "prefix" or "suffix". However the spec
  /// http://docs.aws.amazon.com/AmazonS3/latest/API/RESTBucketPUTnotification.html is not clear
  /// about this behavior.
  void setRule(String name, String value) {
    if (value.length > 1024) {
      throw ArgumentError("value '$value' is more than 1024 long");
    }

    _filterRuleList ??= [];

    for (FilterRule rule in _filterRuleList!) {
      // Remove rule.name is same as given name.
      if (rule.name == name) {
        _filterRuleList!.remove(rule);
      }
    }

    _filterRuleList!.add(FilterRule(name, value));
  }

  void setPrefixRule(String value) {
    setRule("prefix", value);
  }

  void setSuffixRule(String value) {
    setRule("suffix", value);
  }

  List<FilterRule> filterRuleList() {
    return UnmodifiableListView(_filterRuleList ?? []);
  }

  factory Filter.fromJson(Map<String, dynamic> json) => _$FilterFromJson(json);

  Map<String, dynamic> toJson() => _$FilterToJson(this);
}
