// @Root(name = "Rule", strict = false)
import 'package:json_annotation/json_annotation.dart';

import 'retention_duration.dart';
import 'retention_mode.dart';

part 'rule.g.dart';
@JsonSerializable(fieldRename: FieldRename.pascal)
class Rule {
  // @Path(value = "DefaultRetention")
  // @Element(name = "Mode", required = false)
  final RetentionMode mode;

  // @Path(value = "DefaultRetention")
  // @ElementUnion({
  //   @Element(name = "Days", type = RetentionDurationDays.class, required = false),
  //   @Element(name = "Years", type = RetentionDurationYears.class, required = false)
  // })
  @JsonKey(fromJson: RetentionDuration.fromJson, toJson: RetentionDuration.toJsonS)
  final RetentionDuration duration;

  Rule(this.mode, this.duration);

  factory Rule.fromJson(Map<String, dynamic> json) => _$RuleFromJson(json);

  Map<String, dynamic> toJson() => _$RuleToJson(this);

}
