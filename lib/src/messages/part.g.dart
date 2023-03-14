// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'part.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Part _$PartFromJson(Map<String, dynamic> json) => Part(
      json['PartNumber'] as int,
      json['ETag'] as String,
      ResponseDate.fromJson(json['LastModified'] as String?),
      json['Size'] as int? ?? 0,
    );

Map<String, dynamic> _$PartToJson(Part instance) => <String, dynamic>{
      'PartNumber': instance.partNumber,
      'ETag': instance.etagK,
      'LastModified': ResponseDate.toJson(instance.lastModified),
      'Size': instance.size,
    };
