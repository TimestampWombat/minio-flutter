// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'cloud_function_configuration.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

CloudFunctionConfiguration _$CloudFunctionConfigurationFromJson(
        Map<String, dynamic> json) =>
    CloudFunctionConfiguration(
      json['CloudFunction'] as String?,
    )
      ..id = json['Id'] as String?
      ..filter = json['Filter'] == null
          ? null
          : Filter.fromJson(json['Filter'] as Map<String, dynamic>)
      ..events = (json['Events'] as List<dynamic>)
          .map((e) => $enumDecode(_$EventTypeEnumMap, e))
          .toList();

Map<String, dynamic> _$CloudFunctionConfigurationToJson(
        CloudFunctionConfiguration instance) =>
    <String, dynamic>{
      'Id': instance.id,
      'Filter': instance.filter,
      'Events': instance.events.map((e) => _$EventTypeEnumMap[e]!).toList(),
      'CloudFunction': instance.cloudFunction,
    };

const _$EventTypeEnumMap = {
  EventType.OBJECT_CREATED_ANY: 's3:ObjectCreated:*',
  EventType.OBJECT_CREATED_PUT: 's3:ObjectCreated:Put',
  EventType.OBJECT_CREATED_POST: 's3:ObjectCreated:Post',
  EventType.OBJECT_CREATED_COPY: 's3:ObjectCreated:Copy',
  EventType.OBJECT_CREATED_COMPLETE_MULTIPART_UPLOAD:
      's3:ObjectCreated:CompleteMultipartUpload',
  EventType.OBJECT_ACCESSED_GET: 's3:ObjectAccessed:Get',
  EventType.OBJECT_ACCESSED_HEAD: 's3:ObjectAccessed:Head',
  EventType.OBJECT_ACCESSED_ANY: 's3:ObjectAccessed:*',
  EventType.OBJECT_REMOVED_ANY: 's3:ObjectRemoved:*',
  EventType.OBJECT_REMOVED_DELETE: 's3:ObjectRemoved:Delete',
  EventType.OBJECT_REMOVED_DELETED_MARKER_CREATED:
      's3:ObjectRemoved:DeleteMarkerCreated',
  EventType.REDUCED_REDUNDANCY_LOST_OBJECT: 's3:ReducedRedundancyLostObject',
  EventType.BUCKET_CREATED: 's3:BucketCreated',
  EventType.BUCKET_REMOVED: 's3:BucketRemoved',
};
