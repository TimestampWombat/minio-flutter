// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'lifecycle_configuration.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

LifecycleConfiguration _$LifecycleConfigurationFromJson(
        Map<String, dynamic> json) =>
    LifecycleConfiguration(
      (json['Rule'] as List<dynamic>)
          .map((e) => LifecycleRule.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$LifecycleConfigurationToJson(
        LifecycleConfiguration instance) =>
    <String, dynamic>{
      'Rule': instance.rules,
    };
