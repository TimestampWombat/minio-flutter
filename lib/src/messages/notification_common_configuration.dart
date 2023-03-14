import 'dart:collection';

import 'package:json_annotation/json_annotation.dart';

import 'event_type.dart';
import 'filter.dart';
import 'filter_rule.dart';

@JsonSerializable(fieldRename: FieldRename.pascal)
abstract class NotificationCommonConfiguration {
  @JsonKey(name: "Id")
  String? id;

  @JsonKey(name: "Event")
  List<EventType>? _events;

  Filter? filter;

  /// Returns events.
  List<EventType> get events {
    return UnmodifiableListView(_events ?? []);
  }

  /// Sets event.
  set events(List<EventType> events) {
    _events = UnmodifiableListView(events);
  }

  /// sets filter prefix rule.
  void setPrefixRule(String value) {
    filter ??= Filter();
    filter!.setPrefixRule(value);
  }

  /// sets filter suffix rule.
  void setSuffixRule(String value) {
    filter ??= Filter();

    filter!.setSuffixRule(value);
  }

  /// returns filter rule list.
  List<FilterRule> filterRuleList() {
    return UnmodifiableListView(filter == null ? [] : filter!.filterRuleList());
  }
}
