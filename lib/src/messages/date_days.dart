import 'package:json_annotation/json_annotation.dart';

import 'response_date.dart';

part 'date_days.g.dart';

/// Base class for {@link Transition} and {@link Expiration}.
@JsonSerializable(fieldRename: FieldRename.pascal)
class DateDays {
  @JsonKey(fromJson: ResponseDate.fromJson, toJson: ResponseDate.toJson)
  final ResponseDate? date;

  final int? days;

  DateDays([this.date, this.days]);

  factory DateDays.fromJson(Map<String, dynamic> json) =>
      _$DateDaysFromJson(json);

  Map<String, dynamic> toJson() => _$DateDaysToJson(this);
}
