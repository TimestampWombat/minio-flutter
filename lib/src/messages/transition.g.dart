// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'transition.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Transition _$TransitionFromJson(Map<String, dynamic> json) => Transition(
      ResponseDate.fromJson(json['Date'] as String?),
      json['Days'] as int?,
      json['StorageClass'] as String,
    );

Map<String, dynamic> _$TransitionToJson(Transition instance) =>
    <String, dynamic>{
      'Date': ResponseDate.toJson(instance.date),
      'Days': instance.days,
      'StorageClass': instance.storageClass,
    };
