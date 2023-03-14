// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'event_metadata.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

EventMetadata _$EventMetadataFromJson(Map<String, dynamic> json) =>
    EventMetadata(
      json['s3SchemaVersion'] as String?,
      json['configurationId'] as String?,
      json['bucket'] == null
          ? null
          : BucketMetadata.fromJson(json['bucket'] as Map<String, dynamic>),
      json['object'] == null
          ? null
          : ObjectMetadata.fromJson(json['object'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$EventMetadataToJson(EventMetadata instance) =>
    <String, dynamic>{
      's3SchemaVersion': instance.s3SchemaVersion,
      'configurationId': instance.configurationId,
      'bucket': instance.bucket,
      'object': instance.object,
    };
