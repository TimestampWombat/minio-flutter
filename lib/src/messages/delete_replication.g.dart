// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'delete_replication.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

DeleteReplication _$DeleteReplicationFromJson(Map<String, dynamic> json) =>
    DeleteReplication(
      $enumDecodeNullable(_$StatusEnumMap, json['Status']) ?? Status.DISABLED,
    );

Map<String, dynamic> _$DeleteReplicationToJson(DeleteReplication instance) =>
    <String, dynamic>{
      'Status': _$StatusEnumMap[instance.status]!,
    };

const _$StatusEnumMap = {
  Status.DISABLED: 'Disabled',
  Status.ENABLED: 'Enabled',
};
