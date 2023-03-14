// @Root(name = "Years")
import 'package:json_annotation/json_annotation.dart';

import 'retention_duration.dart';
import 'retention_duration_unit.dart';

part 'retention_duration_years.g.dart';
@JsonSerializable()
class RetentionDurationYears implements RetentionDuration {
  final int? years;

  RetentionDurationYears(this.years);

  RetentionDurationUnit unit() {
    return RetentionDurationUnit.YEARS;
  }

  int? duration() {
    return years;
  }

  /// Returns RetentionDurationYears as string.
  @override
  String toString() {
    if (years == null) {
      return "";
    }
    return years.toString() + ((years == 1) ? " year" : " years");
  }

  factory RetentionDurationYears.fromJson(Map<String, dynamic> json) =>
      _$RetentionDurationYearsFromJson(json);

  Map<String, dynamic> toJson() => _$RetentionDurationYearsToJson(this);
}
