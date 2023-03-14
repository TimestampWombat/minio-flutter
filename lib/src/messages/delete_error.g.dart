// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'delete_error.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

DeleteError _$DeleteErrorFromJson(Map<String, dynamic> json) => DeleteError(
      code: json['code'] as String?,
      message: json['message'] as String?,
      bucketName: json['bucketName'] as String?,
      objectName: json['Key'] as String?,
      resource: json['resource'] as String?,
      requestId: json['requestId'] as String?,
      hostId: json['hostId'] as String?,
    );

Map<String, dynamic> _$DeleteErrorToJson(DeleteError instance) =>
    <String, dynamic>{
      'code': instance.code,
      'message': instance.message,
      'bucketName': instance.bucketName,
      'Key': instance.objectName,
      'resource': instance.resource,
      'requestId': instance.requestId,
      'hostId': instance.hostId,
    };
