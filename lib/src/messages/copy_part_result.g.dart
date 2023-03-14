// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'copy_part_result.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

CopyPartResult _$CopyPartResultFromJson(Map<String, dynamic> json) =>
    CopyPartResult(
      json['ETag'] as String,
      ResponseDate.fromJson(json['lastModified'] as String?),
    );

Map<String, dynamic> _$CopyPartResultToJson(CopyPartResult instance) =>
    <String, dynamic>{
      'ETag': instance.etag,
      'lastModified': ResponseDate.toJson(instance.lastModified),
    };
