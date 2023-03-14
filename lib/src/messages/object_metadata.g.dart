// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'object_metadata.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ObjectMetadata _$ObjectMetadataFromJson(Map<String, dynamic> json) =>
    ObjectMetadata(
      json['key'] as String,
      json['size'] as int,
      json['eTag'] as String,
      json['versionId'] as String,
      json['sequencer'] as String,
      (json['userMetadata'] as Map<String, dynamic>?)?.map(
        (k, e) => MapEntry(k, e as String),
      ),
    );

Map<String, dynamic> _$ObjectMetadataToJson(ObjectMetadata instance) =>
    <String, dynamic>{
      'key': instance.key,
      'size': instance.size,
      'eTag': instance.eTag,
      'versionId': instance.versionId,
      'sequencer': instance.sequencer,
      'userMetadata': instance.userMetadataK,
    };
