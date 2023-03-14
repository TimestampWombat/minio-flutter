// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'delete_marker_replication.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

DeleteMarkerReplication _$DeleteMarkerReplicationFromJson(
        Map<String, dynamic> json) =>
    DeleteMarkerReplication(
      $enumDecodeNullable(_$StatusEnumMap, json['Status']) ?? Status.DISABLED,
    );

Map<String, dynamic> _$DeleteMarkerReplicationToJson(
        DeleteMarkerReplication instance) =>
    <String, dynamic>{
      'Status': _$StatusEnumMap[instance.status]!,
    };

const _$StatusEnumMap = {
  Status.DISABLED: 'Disabled',
  Status.ENABLED: 'Enabled',
};
