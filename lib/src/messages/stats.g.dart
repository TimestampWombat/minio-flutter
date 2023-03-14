// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'stats.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Stats _$StatsFromJson(Map<String, dynamic> json) => Stats(
      json['BytesScanned'] as int? ?? -1,
      json['BytesProcessed'] as int? ?? -1,
      json['BytesReturned'] as int? ?? -1,
    );

Map<String, dynamic> _$StatsToJson(Stats instance) => <String, dynamic>{
      'BytesScanned': instance.bytesScanned,
      'BytesProcessed': instance.bytesProcessed,
      'BytesReturned': instance.bytesReturned,
    };
