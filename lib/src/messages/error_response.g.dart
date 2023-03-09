// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'error_response.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ErrorResponse _$ErrorResponseFromJson(Map<String, dynamic> json) =>
    ErrorResponse(
      code: json['Code'] as String?,
    )
      ..message = json['Message'] as String?
      ..bucketName = json['BucketName'] as String?
      ..objectName = json['Key'] as String?
      ..resource = json['Resource'] as String?
      ..requestId = json['RequestId'] as String?
      ..hostId = json['HostId'] as String?;

Map<String, dynamic> _$ErrorResponseToJson(ErrorResponse instance) =>
    <String, dynamic>{
      'Code': instance.code,
      'Message': instance.message,
      'BucketName': instance.bucketName,
      'Key': instance.objectName,
      'Resource': instance.resource,
      'RequestId': instance.requestId,
      'HostId': instance.hostId,
    };
