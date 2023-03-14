// @Root(name = "JSON")
// @edu.umd.cs.findbugs.annotations.SuppressFBWarnings(value = "URF_UNREAD_FIELD")
import 'package:json_annotation/json_annotation.dart';

part 'json_output_serialization.g.dart';

@JsonSerializable(fieldRename: FieldRename.pascal)
class JsonOutputSerialization {
  final String recordDelimiter;

  JsonOutputSerialization(this.recordDelimiter);

  factory JsonOutputSerialization.fromJson(Map<String, dynamic> json) =>
      _$JsonOutputSerializationFromJson(json);

  Map<String, dynamic> toJson() => _$JsonOutputSerializationToJson(this);
}
