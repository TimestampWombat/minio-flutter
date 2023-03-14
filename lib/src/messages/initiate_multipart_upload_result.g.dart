// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'initiate_multipart_upload_result.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

InitiateMultipartUploadResult _$InitiateMultipartUploadResultFromJson(
        Map<String, dynamic> json) =>
    InitiateMultipartUploadResult(
      json['Bucket'] as String,
      json['Key'] as String,
      json['UploadId'] as String,
    );

Map<String, dynamic> _$InitiateMultipartUploadResultToJson(
        InitiateMultipartUploadResult instance) =>
    <String, dynamic>{
      'Bucket': instance.bucketName,
      'Key': instance.objectName,
      'UploadId': instance.uploadId,
    };
