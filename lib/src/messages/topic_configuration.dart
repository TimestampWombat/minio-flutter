// @Root(name = "TopicConfiguration", strict = false)

import 'package:json_annotation/json_annotation.dart';

import 'event_type.dart';
import 'filter.dart';
import 'notification_common_configuration.dart';

part 'topic_configuration.g.dart';
@JsonSerializable(fieldRename: FieldRename.pascal)
class TopicConfiguration extends NotificationCommonConfiguration {
  // @Element(name = "Topic")
  String topic;
  TopicConfiguration(this.topic);

  factory TopicConfiguration.fromJson(Map<String, dynamic> json) =>
      _$TopicConfigurationFromJson(json);

  Map<String, dynamic> toJson() => _$TopicConfigurationToJson(this);
}
