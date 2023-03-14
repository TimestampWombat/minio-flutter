// @Root(name = "InputSerialization")
// @edu.umd.cs.findbugs.annotations.SuppressFBWarnings(value = "URF_UNREAD_FIELD")
import 'package:json_annotation/json_annotation.dart';

import 'compression_type.dart';
import 'csv_input_serialization.dart';
import 'file_header_info.dart';
import 'json_input_serialization.dart';
import 'json_type.dart';
import 'parquet_input_serialization.dart';

part 'input_serialization.g.dart';

@JsonSerializable(fieldRename: FieldRename.pascal)
class InputSerialization {
  // @Element(name = "CompressionType", required = false)
  final CompressionType? compressionType;

  @JsonKey(name: "CSV")
  late final CsvInputSerialization? csv;

  @JsonKey(name: "JSON")
  late final JsonInputSerialization? json;

  late final ParquetInputSerialization? parquet;

  InputSerialization(this.compressionType, this.csv, this.json, this.parquet);

  /// Constructs a InputSerialization object with CSV.
  InputSerialization.csv(
      this.compressionType,
      bool? allowQuotedRecordDelimiter,
      String? comments,
      String? fieldDelimiter,
      FileHeaderInfo? fileHeaderInfo,
      String? quoteCharacter,
      String? quoteEscapeCharacter,
      String? recordDelimiter)
      : csv = CsvInputSerialization(
            allowQuotedRecordDelimiter,
            comments,
            fieldDelimiter,
            fileHeaderInfo,
            quoteCharacter,
            quoteEscapeCharacter,
            recordDelimiter);

  /// Constructs a InputSerialization object with JSON.
  InputSerialization.json(this.compressionType, JsonType type)
      : json = JsonInputSerialization(type);

  /// Constructs a InputSerialization object with Parquet.
  InputSerialization.parquet()
      : compressionType = null,
        parquet = ParquetInputSerialization();

  factory InputSerialization.fromJson(Map<String, dynamic> json) =>
      _$InputSerializationFromJson(json);

  Map<String, dynamic> toJson() => _$InputSerializationToJson(this);
}
