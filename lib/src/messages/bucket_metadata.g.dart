// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'bucket_metadata.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

BucketMetadata _$BucketMetadataFromJson(Map<String, dynamic> json) =>
    BucketMetadata(
      json['name'] as String,
      json['ownerIdentity'] == null
          ? null
          : Identity.fromJson(json['ownerIdentity'] as Map<String, dynamic>),
      json['arn'] as String?,
    );

Map<String, dynamic> _$BucketMetadataToJson(BucketMetadata instance) =>
    <String, dynamic>{
      'name': instance.name,
      'ownerIdentity': instance.ownerIdentity,
      'arn': instance.arn,
    };
