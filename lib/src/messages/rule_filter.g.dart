// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'rule_filter.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

RuleFilter _$RuleFilterFromJson(Map<String, dynamic> json) => RuleFilter(
      json['And'] == null
          ? null
          : AndOperator.fromJson(json['And'] as Map<String, dynamic>),
      json['Prefix'] as String?,
      json['Tag'] == null
          ? null
          : Tag.fromJson(json['Tag'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$RuleFilterToJson(RuleFilter instance) =>
    <String, dynamic>{
      'And': instance.andOperator,
      'Prefix': instance.prefix,
      'Tag': instance.tag,
    };
