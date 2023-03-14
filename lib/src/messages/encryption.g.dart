// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'encryption.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Encryption _$EncryptionFromJson(Map<String, dynamic> json) => Encryption(
      $enumDecode(_$SseAlgorithmEnumMap, json['EncryptionType']),
      json['KMSContext'] as String?,
      json['KMSKeyId'] as String?,
    );

Map<String, dynamic> _$EncryptionToJson(Encryption instance) =>
    <String, dynamic>{
      'EncryptionType': _$SseAlgorithmEnumMap[instance.encryptionType]!,
      'KMSContext': instance.kmsContext,
      'KMSKeyId': instance.kmsKeyId,
    };

const _$SseAlgorithmEnumMap = {
  SseAlgorithm.AES256: 'AES256',
  SseAlgorithm.AWS_KMS: 'aws:kms',
};
