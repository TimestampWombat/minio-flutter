// @Root(name = "Days")
import 'package:json_annotation/json_annotation.dart';

import 'retention_duration.dart';
import 'retention_duration_unit.dart';

part 'retention_duration_days.g.dart';
@JsonSerializable()
class RetentionDurationDays implements RetentionDuration {
  final int? days;

  RetentionDurationDays(this.days);

  RetentionDurationUnit unit() {
    return RetentionDurationUnit.DAYS;
  }

  int? duration() {
    return days;
  }

  /// Returns RetentionDurationDays as string.
  @override
  String toString() {
    if (days == null) {
      return "";
    }
    return days.toString() + ((days == 1) ? " day" : " days");
  }

  factory RetentionDurationDays.fromJson(Map<String, dynamic> json) =>
      _$RetentionDurationDaysFromJson(json);

  Map<String, dynamic> toJson() => _$RetentionDurationDaysToJson(this);
}
