// @Root(name = "CSV")
// @edu.umd.cs.findbugs.annotations.SuppressFBWarnings(value = "URF_UNREAD_FIELD")
import 'package:json_annotation/json_annotation.dart';

import 'quote_fields.dart';

part 'csv_output_serialization.g.dart';

@JsonSerializable(fieldRename: FieldRename.pascal)
class CsvOutputSerialization {
  final String? fieldDelimiter;

  final String? quoteCharacter;

  final String? quoteEscapeCharacter;

  final QuoteFields? quoteFields;

  final String? recordDelimiter;

  CsvOutputSerialization({
    this.fieldDelimiter,
    this.quoteCharacter,
    this.quoteEscapeCharacter,
    this.quoteFields,
    this.recordDelimiter,
  });

  factory CsvOutputSerialization.fromJson(Map<String, dynamic> json) =>
      _$CsvOutputSerializationFromJson(json);

  Map<String, dynamic> toJson() => _$CsvOutputSerializationToJson(this);
}
