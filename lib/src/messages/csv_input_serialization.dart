// @Root(name = "CSV")
// @edu.umd.cs.findbugs.annotations.SuppressFBWarnings(value = "URF_UNREAD_FIELD")

import 'package:json_annotation/json_annotation.dart';

import 'file_header_info.dart';

part 'csv_input_serialization.g.dart';

@JsonSerializable(fieldRename: FieldRename.pascal)
class CsvInputSerialization {
  final bool? allowQuotedRecordDelimiter;

  final String? comments;

  final String? fieldDelimiter;

  final FileHeaderInfo? fileHeaderInfo;

  final String? quoteCharacter;

  final String? quoteEscapeCharacter;

  final String? recordDelimiter;
  
  CsvInputSerialization({
    this.allowQuotedRecordDelimiter,
    this.comments,
    this.fieldDelimiter,
    this.fileHeaderInfo,
    this.quoteCharacter,
    this.quoteEscapeCharacter,
    this.recordDelimiter,
  });

  factory CsvInputSerialization.fromJson(Map<String, dynamic> json) =>
      _$CsvInputSerializationFromJson(json);

  Map<String, dynamic> toJson() => _$CsvInputSerializationToJson(this);
}
