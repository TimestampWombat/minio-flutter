// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'retention.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Retention _$RetentionFromJson(Map<String, dynamic> json) => Retention(
      $enumDecodeNullable(_$RetentionModeEnumMap, json['Mode']),
      ResponseDate.fromJson(json['RetainUntilDate'] as String?),
    );

Map<String, dynamic> _$RetentionToJson(Retention instance) => <String, dynamic>{
      'Mode': _$RetentionModeEnumMap[instance.mode],
      'RetainUntilDate': ResponseDate.toJson(instance.retainUntilDate),
    };

const _$RetentionModeEnumMap = {
  RetentionMode.GOVERNANCE: 'GOVERNANCE',
  RetentionMode.COMPLIANCE: 'COMPLIANCE',
};
