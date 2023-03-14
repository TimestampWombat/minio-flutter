// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'delete_object.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

DeleteObject _$DeleteObjectFromJson(Map<String, dynamic> json) => DeleteObject(
      json['Key'] as String,
      json['VersionId'] as String?,
    );

Map<String, dynamic> _$DeleteObjectToJson(DeleteObject instance) =>
    <String, dynamic>{
      'Key': instance.name,
      'VersionId': instance.versionId,
    };
