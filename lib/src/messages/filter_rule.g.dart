// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'filter_rule.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

FilterRule _$FilterRuleFromJson(Map<String, dynamic> json) => FilterRule(
      json['Name'] as String,
      json['Value'] as String,
    );

Map<String, dynamic> _$FilterRuleToJson(FilterRule instance) =>
    <String, dynamic>{
      'Name': instance.name,
      'Value': instance.value,
    };
