// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'complete_multipart_upload.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

CompleteMultipartUpload _$CompleteMultipartUploadFromJson(
        Map<String, dynamic> json) =>
    CompleteMultipartUpload(
      (json['Part'] as List<dynamic>)
          .map((e) => Part.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$CompleteMultipartUploadToJson(
        CompleteMultipartUpload instance) =>
    <String, dynamic>{
      'Part': instance.partList,
    };
