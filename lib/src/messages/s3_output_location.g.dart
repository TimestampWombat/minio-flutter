// GENERATED CODE - DO NOT MODIFY BY HAND

part of 's3_output_location.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

S3OutputLocation _$S3OutputLocationFromJson(Map<String, dynamic> json) =>
    S3OutputLocation(
      accessControlList: json['AccessControlList'] == null
          ? null
          : AccessControlList.fromJson(
              json['AccessControlList'] as Map<String, dynamic>),
      bucketName: json['BucketName'] as String,
      cannedAcl: $enumDecodeNullable(_$CannedAclEnumMap, json['CannedAcl']),
      encryption: json['Encryption'] == null
          ? null
          : Encryption.fromJson(json['Encryption'] as Map<String, dynamic>),
      prefix: json['Prefix'] as String,
      storageClass: json['StorageClass'] as String?,
      tagging: json['Tagging'] == null
          ? null
          : Tags.fromJson(json['Tagging'] as Map<String, dynamic>),
      userMetadata: json['UserMetadata'] == null
          ? null
          : UserMetadata.fromJson(json['UserMetadata'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$S3OutputLocationToJson(S3OutputLocation instance) =>
    <String, dynamic>{
      'AccessControlList': instance.accessControlList,
      'BucketName': instance.bucketName,
      'CannedAcl': _$CannedAclEnumMap[instance.cannedAcl],
      'Encryption': instance.encryption,
      'Prefix': instance.prefix,
      'StorageClass': instance.storageClass,
      'Tagging': instance.tagging,
      'UserMetadata': instance.userMetadata,
    };

const _$CannedAclEnumMap = {
  CannedAcl.PRIVATE: 'private',
  CannedAcl.PUBLIC_READ: 'public-read',
  CannedAcl.PUBLIC_READ_WRITE: 'public-read-write',
  CannedAcl.AUTHENTICATED_READ: 'authenticated-read',
  CannedAcl.AWS_EXEC_READ: 'aws-exec-read',
  CannedAcl.BUCKET_OWNER_READ: 'bucket-owner-read',
  CannedAcl.BUCKET_OWNER_FULL_CONTROL: 'bucket-owner-full-control',
};
