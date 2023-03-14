// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'sse_configuration_rule.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

SseConfigurationRule _$SseConfigurationRuleFromJson(
        Map<String, dynamic> json) =>
    SseConfigurationRule(
      $enumDecode(_$SseAlgorithmEnumMap, json['SSEAlgorithm']),
      json['KMSMasterKeyID'] as String?,
    );

Map<String, dynamic> _$SseConfigurationRuleToJson(
        SseConfigurationRule instance) =>
    <String, dynamic>{
      'KMSMasterKeyID': instance.kmsMasterKeyId,
      'SSEAlgorithm': _$SseAlgorithmEnumMap[instance.sseAlgorithm]!,
    };

const _$SseAlgorithmEnumMap = {
  SseAlgorithm.AES256: 'AES256',
  SseAlgorithm.AWS_KMS: 'aws:kms',
};
