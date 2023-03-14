// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'deleted_object.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

DeletedObject _$DeletedObjectFromJson(Map<String, dynamic> json) =>
    DeletedObject(
      name: json['Key'] as String,
      versionId: json['VersionId'] as String?,
      deleteMarker: json['DeleteMarker'] as bool? ?? false,
      deleteMarkerVersionId: json['DeleteMarkerVersionId'] as String?,
    );

Map<String, dynamic> _$DeletedObjectToJson(DeletedObject instance) =>
    <String, dynamic>{
      'Key': instance.name,
      'VersionId': instance.versionId,
      'DeleteMarker': instance.deleteMarker,
      'DeleteMarkerVersionId': instance.deleteMarkerVersionId,
    };
