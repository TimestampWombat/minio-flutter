// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'event.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Event _$EventFromJson(Map<String, dynamic> json) => Event(
      eventVersion: json['eventVersion'] as String,
      eventSource: json['eventSource'] as String,
      awsRegion: json['awsRegion'] as String,
      eventName: $enumDecode(_$EventTypeEnumMap, json['eventName']),
      userIdentity: json['userIdentity'] == null
          ? null
          : Identity.fromJson(json['userIdentity'] as Map<String, dynamic>),
      requestParametersK:
          (json['requestParameters'] as Map<String, dynamic>?)?.map(
        (k, e) => MapEntry(k, e as String),
      ),
      responseElementsK:
          (json['responseElements'] as Map<String, dynamic>?)?.map(
        (k, e) => MapEntry(k, e as String),
      ),
      s3: json['s3'] == null
          ? null
          : EventMetadata.fromJson(json['s3'] as Map<String, dynamic>),
      source: json['source'] == null
          ? null
          : Source.fromJson(json['source'] as Map<String, dynamic>),
      eventTimeK: ResponseDate.fromJson(json['eventTime'] as String?),
    );

Map<String, dynamic> _$EventToJson(Event instance) => <String, dynamic>{
      'eventVersion': instance.eventVersion,
      'eventSource': instance.eventSource,
      'awsRegion': instance.awsRegion,
      'eventName': _$EventTypeEnumMap[instance.eventName]!,
      'userIdentity': instance.userIdentity,
      'requestParameters': instance.requestParametersK,
      'responseElements': instance.responseElementsK,
      's3': instance.s3,
      'source': instance.source,
      'eventTime': ResponseDate.toJson(instance.eventTimeK),
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
