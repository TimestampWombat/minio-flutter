// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'copy_object_result.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

CopyObjectResult _$CopyObjectResultFromJson(Map<String, dynamic> json) =>
    CopyObjectResult(
      json['ETag'] as String,
      ResponseDate.fromJson(json['LastModified'] as String?),
    );

Map<String, dynamic> _$CopyObjectResultToJson(CopyObjectResult instance) =>
    <String, dynamic>{
      'ETag': instance.etag,
      'LastModified': ResponseDate.toJson(instance.lastModified),
    };
