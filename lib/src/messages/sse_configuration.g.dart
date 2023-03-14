// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'sse_configuration.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

SseConfiguration _$SseConfigurationFromJson(Map<String, dynamic> json) =>
    SseConfiguration(
      json['Rule'] == null
          ? null
          : SseConfigurationRule.fromJson(json['Rule'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$SseConfigurationToJson(SseConfiguration instance) =>
    <String, dynamic>{
      'Rule': instance.rule,
    };
