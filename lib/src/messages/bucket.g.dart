// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'bucket.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Bucket _$BucketFromJson(Map<String, dynamic> json) => Bucket(
      json['Name'] as String,
      ResponseDate.fromJson(json['CreationDate'] as String?),
    );

Map<String, dynamic> _$BucketToJson(Bucket instance) => <String, dynamic>{
      'Name': instance.name,
      'CreationDate': ResponseDate.toJson(instance.creationDate),
    };
