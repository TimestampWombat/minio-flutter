// @Root(name = "Transition")

import 'package:json_annotation/json_annotation.dart';

import 'date_days.dart';
import 'response_date.dart';

part 'transition.g.dart';

@JsonSerializable(fieldRename: FieldRename.pascal)
class Transition extends DateDays {
  final String storageClass;

  Transition(super.date, super.days, this.storageClass) {
    if (!((date != null) ^ (days != null))) {
      throw ArgumentError("Only one of date or days must be set");
    }
    if (storageClass.isEmpty) {
      throw ArgumentError("StorageClass must be provided");
    }
  }

  Transition.dateTime(DateTime? date, int? days, String storageClass)
      : this(date == null ? null : ResponseDate(date), days, storageClass);

  factory Transition.fromJson(Map<String, dynamic> json) =>
      _$TransitionFromJson(json);

  Map<String, dynamic> toJson() => _$TransitionToJson(this);
}
