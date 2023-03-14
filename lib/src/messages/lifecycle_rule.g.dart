// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'lifecycle_rule.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

LifecycleRule _$LifecycleRuleFromJson(Map<String, dynamic> json) =>
    LifecycleRule(
      $enumDecode(_$StatusEnumMap, json['Status']),
      json['AbortIncompleteMultipartUpload'] == null
          ? null
          : AbortIncompleteMultipartUpload.fromJson(
              json['AbortIncompleteMultipartUpload'] as Map<String, dynamic>),
      json['Expiration'] == null
          ? null
          : Expiration.fromJson(json['Expiration'] as Map<String, dynamic>),
      RuleFilter.fromJson(json['Filter'] as Map<String, dynamic>),
      json['ID'] as String?,
      json['NoncurrentVersionExpiration'] == null
          ? null
          : NoncurrentVersionExpiration.fromJson(
              json['NoncurrentVersionExpiration'] as Map<String, dynamic>),
      json['NoncurrentVersionTransition'] == null
          ? null
          : NoncurrentVersionTransition.fromJson(
              json['NoncurrentVersionTransition'] as Map<String, dynamic>),
      json['Transition'] == null
          ? null
          : Transition.fromJson(json['Transition'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$LifecycleRuleToJson(LifecycleRule instance) =>
    <String, dynamic>{
      'AbortIncompleteMultipartUpload': instance.abortIncompleteMultipartUpload,
      'Expiration': instance.expiration,
      'Filter': instance.filter,
      'ID': instance.id,
      'NoncurrentVersionExpiration': instance.noncurrentVersionExpiration,
      'NoncurrentVersionTransition': instance.noncurrentVersionTransition,
      'Status': _$StatusEnumMap[instance.status]!,
      'Transition': instance.transition,
    };

const _$StatusEnumMap = {
  Status.DISABLED: 'Disabled',
  Status.ENABLED: 'Enabled',
};
