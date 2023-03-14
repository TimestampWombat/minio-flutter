// @Root(name = "LifecycleConfiguration")
// @Namespace(reference = "http://s3.amazonaws.com/doc/2006-03-01/")
import 'dart:collection';

import 'package:json_annotation/json_annotation.dart';

import 'lifecycle_rule.dart';

part 'lifecycle_configuration.g.dart';

@JsonSerializable(fieldRename: FieldRename.pascal)
class LifecycleConfiguration {
  @JsonKey(name: "Rule")
  late final List<LifecycleRule> rules;

  /// Constructs lifecycle configuration.
  LifecycleConfiguration(List<LifecycleRule> rules) {
    this.rules = UnmodifiableListView(rules);
    if (rules.isEmpty) {
      throw ArgumentError("Rules must not be empty");
    }
  }

  factory LifecycleConfiguration.fromJson(Map<String, dynamic> json) =>
      _$LifecycleConfigurationFromJson(json);

  Map<String, dynamic> toJson() => _$LifecycleConfigurationToJson(this);
}
