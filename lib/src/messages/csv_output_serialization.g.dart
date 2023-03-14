// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'csv_output_serialization.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

CsvOutputSerialization _$CsvOutputSerializationFromJson(
        Map<String, dynamic> json) =>
    CsvOutputSerialization(
      fieldDelimiter: json['FieldDelimiter'] as String?,
      quoteCharacter: json['QuoteCharacter'] as String?,
      quoteEscapeCharacter: json['QuoteEscapeCharacter'] as String?,
      quoteFields:
          $enumDecodeNullable(_$QuoteFieldsEnumMap, json['QuoteFields']),
      recordDelimiter: json['RecordDelimiter'] as String?,
    );

Map<String, dynamic> _$CsvOutputSerializationToJson(
        CsvOutputSerialization instance) =>
    <String, dynamic>{
      'FieldDelimiter': instance.fieldDelimiter,
      'QuoteCharacter': instance.quoteCharacter,
      'QuoteEscapeCharacter': instance.quoteEscapeCharacter,
      'QuoteFields': _$QuoteFieldsEnumMap[instance.quoteFields],
      'RecordDelimiter': instance.recordDelimiter,
    };

const _$QuoteFieldsEnumMap = {
  QuoteFields.ALWAYS: 'ALWAYS',
  QuoteFields.ASNEEDED: 'ASNEEDED',
};
