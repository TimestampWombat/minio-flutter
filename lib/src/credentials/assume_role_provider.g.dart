// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'assume_role_provider.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

AssumeRoleResponse _$AssumeRoleResponseFromJson(Map<String, dynamic> json) =>
    AssumeRoleResponse(
      Credentials.fromJson(json['Credentials'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$AssumeRoleResponseToJson(AssumeRoleResponse instance) =>
    <String, dynamic>{
      'Credentials': instance.credentials,
    };
