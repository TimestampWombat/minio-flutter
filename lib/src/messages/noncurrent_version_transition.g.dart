// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'noncurrent_version_transition.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

NoncurrentVersionTransition _$NoncurrentVersionTransitionFromJson(
        Map<String, dynamic> json) =>
    NoncurrentVersionTransition(
      json['NoncurrentDays'] as int,
      json['StorageClass'] as String,
    );

Map<String, dynamic> _$NoncurrentVersionTransitionToJson(
        NoncurrentVersionTransition instance) =>
    <String, dynamic>{
      'NoncurrentDays': instance.noncurrentDays,
      'StorageClass': instance.storageClass,
    };
