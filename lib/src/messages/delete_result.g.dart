// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'delete_result.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

DeleteResult _$DeleteResultFromJson(Map<String, dynamic> json) => DeleteResult(
      (json['Deleted'] as List<dynamic>?)
          ?.map((e) => DeletedObject.fromJson(e as Map<String, dynamic>))
          .toList(),
      (json['Error'] as List<dynamic>?)
          ?.map((e) => DeleteError.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$DeleteResultToJson(DeleteResult instance) =>
    <String, dynamic>{
      'Deleted': instance.objectListK,
      'Error': instance.errorListK,
    };
