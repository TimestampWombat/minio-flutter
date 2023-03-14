// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'expiration.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Expiration _$ExpirationFromJson(Map<String, dynamic> json) => Expiration(
      ResponseDate.fromJson(json['Date'] as String?),
      json['Days'] as int?,
      json['ExpiredObjectDeleteMarker'] as bool?,
    );

Map<String, dynamic> _$ExpirationToJson(Expiration instance) =>
    <String, dynamic>{
      'Date': ResponseDate.toJson(instance.date),
      'Days': instance.days,
      'ExpiredObjectDeleteMarker': instance.expiredObjectDeleteMarker,
    };
