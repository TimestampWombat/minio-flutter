// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'upload.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Upload _$UploadFromJson(Map<String, dynamic> json) => Upload(
      json['Key'] as String,
      json['UploadId'] as String,
      json['Initiator'] == null
          ? null
          : Initiator.fromJson(json['Initiator'] as Map<String, dynamic>),
      json['Owner'] == null
          ? null
          : Owner.fromJson(json['Owner'] as Map<String, dynamic>),
      json['StorageClass'] as String?,
      ResponseDate.fromJson(json['Initiated'] as String?),
    )
      ..aggregatedPartSize = json['AggregatedPartSize'] as int
      ..encodingType = json['EncodingType'] as String?;

Map<String, dynamic> _$UploadToJson(Upload instance) => <String, dynamic>{
      'Key': instance.objectNameK,
      'UploadId': instance.uploadId,
      'Initiator': instance.initiator,
      'Owner': instance.owner,
      'StorageClass': instance.storageClass,
      'Initiated': ResponseDate.toJson(instance.initiated),
      'AggregatedPartSize': instance.aggregatedPartSize,
      'EncodingType': instance.encodingType,
    };
