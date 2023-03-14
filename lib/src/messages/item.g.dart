// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'item.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Item _$ItemFromJson(Map<String, dynamic> json) => Item(
      json['Etag'] as String?,
      json['Key'] as String,
      ResponseDate.fromJson(json['LastModified'] as String?),
      json['Owner'] == null
          ? null
          : Owner.fromJson(json['Owner'] as Map<String, dynamic>),
      json['Size'] as int?,
      json['StorageClass'] as String?,
      json['IsLatest'] as bool?,
      json['VersionId'] as String?,
      (json['UserMetadata'] as Map<String, dynamic>?)?.map(
        (k, e) => MapEntry(k, e as String),
      ),
    );

Map<String, dynamic> _$ItemToJson(Item instance) => <String, dynamic>{
      'Etag': instance.etag,
      'Key': instance.objectNameK,
      'LastModified': ResponseDate.toJson(instance.lastModified),
      'Owner': instance.owner,
      'Size': instance.size,
      'StorageClass': instance.storageClass,
      'IsLatest': instance.isLatest,
      'VersionId': instance.versionId,
      'UserMetadata': instance.userMetadataK,
    };
