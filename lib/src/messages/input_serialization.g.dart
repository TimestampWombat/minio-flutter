// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'input_serialization.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

InputSerialization _$InputSerializationFromJson(Map<String, dynamic> json) =>
    InputSerialization(
      $enumDecodeNullable(_$CompressionTypeEnumMap, json['CompressionType']),
      json['CSV'] == null
          ? null
          : CsvInputSerialization.fromJson(json['CSV'] as Map<String, dynamic>),
      json['JSON'] == null
          ? null
          : JsonInputSerialization.fromJson(
              json['JSON'] as Map<String, dynamic>),
      json['Parquet'] == null
          ? null
          : ParquetInputSerialization.fromJson(
              json['Parquet'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$InputSerializationToJson(InputSerialization instance) =>
    <String, dynamic>{
      'CompressionType': _$CompressionTypeEnumMap[instance.compressionType],
      'CSV': instance.csv,
      'JSON': instance.json,
      'Parquet': instance.parquet,
    };

const _$CompressionTypeEnumMap = {
  CompressionType.NONE: 'NONE',
  CompressionType.GZIP: 'GZIP',
  CompressionType.BZIP2: 'BZIP2',
};
