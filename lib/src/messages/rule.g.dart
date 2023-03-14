// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'rule.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Rule _$RuleFromJson(Map<String, dynamic> json) => Rule(
      $enumDecode(_$RetentionModeEnumMap, json['Mode']),
      RetentionDuration.fromJson(json['Duration'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$RuleToJson(Rule instance) => <String, dynamic>{
      'Mode': _$RetentionModeEnumMap[instance.mode]!,
      'Duration': RetentionDuration.toJsonS(instance.duration),
    };

const _$RetentionModeEnumMap = {
  RetentionMode.GOVERNANCE: 'GOVERNANCE',
  RetentionMode.COMPLIANCE: 'COMPLIANCE',
};
