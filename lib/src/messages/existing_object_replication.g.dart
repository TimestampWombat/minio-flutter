// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'existing_object_replication.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ExistingObjectReplication _$ExistingObjectReplicationFromJson(
        Map<String, dynamic> json) =>
    ExistingObjectReplication(
      $enumDecode(_$StatusEnumMap, json['Status']),
    );

Map<String, dynamic> _$ExistingObjectReplicationToJson(
        ExistingObjectReplication instance) =>
    <String, dynamic>{
      'Status': _$StatusEnumMap[instance.status]!,
    };

const _$StatusEnumMap = {
  Status.DISABLED: 'Disabled',
  Status.ENABLED: 'Enabled',
};
