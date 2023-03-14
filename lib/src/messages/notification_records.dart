import 'dart:collection';

import 'package:json_annotation/json_annotation.dart';

import 'event.dart';

/// Object representation of JSON format of <a
/// href="http://docs.aws.amazon.com/AmazonS3/latest/dev/notification-content-structure.html">Event
/// Message Structure</a>.
// @edu.umd.cs.findbugs.annotations.SuppressFBWarnings(
//     value = "UwF",
//     justification = "Everything in this class is initialized by JSON unmarshalling.")

part 'notification_records.g.dart';

@JsonSerializable(fieldRename: FieldRename.pascal)
class NotificationRecords {
  @JsonKey(name: "Records")
  final List<Event>? eventsK;

  NotificationRecords(this.eventsK);

  List<Event> events() {
    return UnmodifiableListView(eventsK ?? []);
  }

  factory NotificationRecords.fromJson(Map<String, dynamic> json) =>
      _$NotificationRecordsFromJson(json);

  Map<String, dynamic> toJson() => _$NotificationRecordsToJson(this);
}
