// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'delete_request.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

DeleteRequest _$DeleteRequestFromJson(Map<String, dynamic> json) =>
    DeleteRequest(
      (json['Object'] as List<dynamic>)
          .map((e) => DeleteObject.fromJson(e as Map<String, dynamic>))
          .toList(),
      json['Quiet'] as bool,
    );

Map<String, dynamic> _$DeleteRequestToJson(DeleteRequest instance) =>
    <String, dynamic>{
      'Quiet': instance.quiet,
      'Object': instance.objectList,
    };
