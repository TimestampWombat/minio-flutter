// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'delete_marker.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

DeleteMarker _$DeleteMarkerFromJson(Map<String, dynamic> json) => DeleteMarker(
      json['etag'] as String?,
      json['Key'] as String,
      ResponseDate.fromJson(json['lastModified'] as String?),
      json['owner'] == null
          ? null
          : Owner.fromJson(json['owner'] as Map<String, dynamic>),
      json['size'] as int?,
      json['storageClass'] as String?,
      json['isLatest'] as bool?,
      json['versionId'] as String?,
      (json['UserMetadata'] as Map<String, dynamic>?)?.map(
        (k, e) => MapEntry(k, e as String),
      ),
    );

Map<String, dynamic> _$DeleteMarkerToJson(DeleteMarker instance) =>
    <String, dynamic>{
      'etag': instance.etag,
      'Key': instance.objectNameK,
      'lastModified': ResponseDate.toJson(instance.lastModified),
      'owner': instance.owner,
      'size': instance.size,
      'storageClass': instance.storageClass,
      'isLatest': instance.isLatest,
      'versionId': instance.versionId,
      'UserMetadata': instance.userMetadataK,
    };
