// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'json_input_serialization.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

JsonInputSerialization _$JsonInputSerializationFromJson(
        Map<String, dynamic> json) =>
    JsonInputSerialization(
      $enumDecode(_$JsonTypeEnumMap, json['Type']),
    );

Map<String, dynamic> _$JsonInputSerializationToJson(
        JsonInputSerialization instance) =>
    <String, dynamic>{
      'Type': _$JsonTypeEnumMap[instance.type]!,
    };

const _$JsonTypeEnumMap = {
  JsonType.DOCUMENT: 'DOCUMENT',
  JsonType.LINES: 'LINES',
};
