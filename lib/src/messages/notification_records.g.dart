// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'notification_records.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

NotificationRecords _$NotificationRecordsFromJson(Map<String, dynamic> json) =>
    NotificationRecords(
      (json['Records'] as List<dynamic>?)
          ?.map((e) => Event.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$NotificationRecordsToJson(
        NotificationRecords instance) =>
    <String, dynamic>{
      'Records': instance.eventsK,
    };
