// @Root(name = "JSON")
// @edu.umd.cs.findbugs.annotations.SuppressFBWarnings(value = "URF_UNREAD_FIELD")
import 'package:json_annotation/json_annotation.dart';

import 'json_type.dart';

part 'json_input_serialization.g.dart';

@JsonSerializable(fieldRename: FieldRename.pascal)
class JsonInputSerialization {
  final JsonType type;

  JsonInputSerialization(this.type);

  factory JsonInputSerialization.fromJson(Map<String, dynamic> json) =>
      _$JsonInputSerializationFromJson(json);

  Map<String, dynamic> toJson() => _$JsonInputSerializationToJson(this);
}
