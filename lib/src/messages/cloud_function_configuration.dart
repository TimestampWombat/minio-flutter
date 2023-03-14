// @Root(name = "CloudFunctionConfiguration", strict = false)

import 'package:json_annotation/json_annotation.dart';

import 'event_type.dart';
import 'filter.dart';
import 'notification_common_configuration.dart';

part 'cloud_function_configuration.g.dart';

@JsonSerializable(fieldRename: FieldRename.pascal)
class CloudFunctionConfiguration extends NotificationCommonConfiguration {
  // @Element(name = "CloudFunction")
  String? cloudFunction;

  CloudFunctionConfiguration(this.cloudFunction);

  factory CloudFunctionConfiguration.fromJson(Map<String, dynamic> json) =>
      _$CloudFunctionConfigurationFromJson(json);

  Map<String, dynamic> toJson() => _$CloudFunctionConfigurationToJson(this);
}
