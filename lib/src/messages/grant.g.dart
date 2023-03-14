// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'grant.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Grant _$GrantFromJson(Map<String, dynamic> json) => Grant(
      json['Grantee'] == null
          ? null
          : Grantee.fromJson(json['Grantee'] as Map<String, dynamic>),
      $enumDecodeNullable(_$PermissionEnumMap, json['Permission']),
    );

Map<String, dynamic> _$GrantToJson(Grant instance) => <String, dynamic>{
      'Grantee': instance.grantee,
      'Permission': _$PermissionEnumMap[instance.permission],
    };

const _$PermissionEnumMap = {
  Permission.FULL_CONTROL: 'FULL_CONTROL',
  Permission.WRITE: 'WRITE',
  Permission.WRITE_ACP: 'WRITE_ACP',
  Permission.READ: 'READ',
  Permission.READ_ACP: 'READ_ACP',
};
