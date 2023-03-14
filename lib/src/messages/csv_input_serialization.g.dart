// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'csv_input_serialization.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

CsvInputSerialization _$CsvInputSerializationFromJson(
        Map<String, dynamic> json) =>
    CsvInputSerialization(
      json['AllowQuotedRecordDelimiter'] as bool?,
      json['Comments'] as String?,
      json['FieldDelimiter'] as String?,
      $enumDecodeNullable(_$FileHeaderInfoEnumMap, json['FileHeaderInfo']),
      json['QuoteCharacter'] as String?,
      json['QuoteEscapeCharacter'] as String?,
      json['RecordDelimiter'] as String?,
    );

Map<String, dynamic> _$CsvInputSerializationToJson(
        CsvInputSerialization instance) =>
    <String, dynamic>{
      'AllowQuotedRecordDelimiter': instance.allowQuotedRecordDelimiter,
      'Comments': instance.comments,
      'FieldDelimiter': instance.fieldDelimiter,
      'FileHeaderInfo': _$FileHeaderInfoEnumMap[instance.fileHeaderInfo],
      'QuoteCharacter': instance.quoteCharacter,
      'QuoteEscapeCharacter': instance.quoteEscapeCharacter,
      'RecordDelimiter': instance.recordDelimiter,
    };

const _$FileHeaderInfoEnumMap = {
  FileHeaderInfo.USE: 'USE',
  FileHeaderInfo.IGNORE: 'IGNORE',
  FileHeaderInfo.NONE: 'NONE',
};
