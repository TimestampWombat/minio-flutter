// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'access_control_list.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

AccessControlList _$AccessControlListFromJson(Map<String, dynamic> json) =>
    AccessControlList(
      (json['Grant'] as List<dynamic>)
          .map((e) => Grant.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$AccessControlListToJson(AccessControlList instance) =>
    <String, dynamic>{
      'Grant': instance.grants,
    };
