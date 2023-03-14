// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'sse_kms_encrypted_objects.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

SseKmsEncryptedObjects _$SseKmsEncryptedObjectsFromJson(
        Map<String, dynamic> json) =>
    SseKmsEncryptedObjects(
      $enumDecode(_$StatusEnumMap, json['Status']),
    );

Map<String, dynamic> _$SseKmsEncryptedObjectsToJson(
        SseKmsEncryptedObjects instance) =>
    <String, dynamic>{
      'Status': _$StatusEnumMap[instance.status]!,
    };

const _$StatusEnumMap = {
  Status.DISABLED: 'Disabled',
  Status.ENABLED: 'Enabled',
};
