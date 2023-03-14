// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'complete_multipart_upload_output.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

CompleteMultipartUploadOutput _$CompleteMultipartUploadOutputFromJson(
        Map<String, dynamic> json) =>
    CompleteMultipartUploadOutput(
      location: json['Location'] as String,
      bucket: json['Bucket'] as String,
      object: json['Key'] as String,
      etag: json['Etag'] as String,
      checksumCRC32: json['ChecksumCRC32'] as String?,
      checksumCRC32C: json['ChecksumCRC32C'] as String?,
      checksumSHA1: json['ChecksumSHA1'] as String?,
      checksumSHA256: json['ChecksumSHA256'] as String?,
    );

Map<String, dynamic> _$CompleteMultipartUploadOutputToJson(
        CompleteMultipartUploadOutput instance) =>
    <String, dynamic>{
      'Location': instance.location,
      'Bucket': instance.bucket,
      'Key': instance.object,
      'Etag': instance.etag,
      'ChecksumCRC32': instance.checksumCRC32,
      'ChecksumCRC32C': instance.checksumCRC32C,
      'ChecksumSHA1': instance.checksumSHA1,
      'ChecksumSHA256': instance.checksumSHA256,
    };
