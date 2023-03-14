// @Root(name = "Expiration")
import 'package:json_annotation/json_annotation.dart';

import 'date_days.dart';

import 'response_date.dart';

part 'expiration.g.dart';

@JsonSerializable(fieldRename: FieldRename.pascal)
class Expiration extends DateDays {
  final bool? expiredObjectDeleteMarker;

  Expiration(super.date, super.days, this.expiredObjectDeleteMarker) {
    if (expiredObjectDeleteMarker != null) {
      if (date != null || days != null) {
        throw ArgumentError(
            "ExpiredObjectDeleteMarker must not be provided along with Date and Days");
      }
    } else if (!((date != null) ^ (days != null))) {
      throw ArgumentError("Only one of date or days must be set");
    }
  }

  Expiration.dateTime(
      DateTime? date, int? days, bool? expiredObjectDeleteMarker)
      : this(date == null ? null : ResponseDate(date), days,
            expiredObjectDeleteMarker);

  factory Expiration.fromJson(Map<String, dynamic> json) =>
      _$ExpirationFromJson(json);

  Map<String, dynamic> toJson() => _$ExpirationToJson(this);
}
