// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'date_days.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

DateDays _$DateDaysFromJson(Map<String, dynamic> json) => DateDays(
      ResponseDate.fromJson(json['Date'] as String?),
      json['Days'] as int?,
    );

Map<String, dynamic> _$DateDaysToJson(DateDays instance) => <String, dynamic>{
      'Date': ResponseDate.toJson(instance.date),
      'Days': instance.days,
    };
