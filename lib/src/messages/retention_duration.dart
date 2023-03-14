import 'retention_duration_days.dart';
import 'retention_duration_unit.dart';
import 'retention_duration_years.dart';

/// Retention duration of {@link ObjectLockConfiguration}
abstract class RetentionDuration {
  RetentionDurationUnit unit();

  int? duration();

  factory RetentionDuration.fromJson(Map<String, dynamic> json) {
    if (json['days'] != null) {
      return RetentionDurationDays.fromJson(json);
    } else if (json['years'] != null) {
      return RetentionDurationYears.fromJson(json);
    } else {
      throw ArgumentError('Invalid RetentionDuration');
    }
  }

  Map<String, dynamic> toJson();

  static Map<String, dynamic> toJsonS(RetentionDuration duration) {
    return duration.toJson();
  }
}
