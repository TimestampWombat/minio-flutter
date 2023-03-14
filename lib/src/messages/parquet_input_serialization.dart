// @Root(name = "Parquet")

import 'package:json_annotation/json_annotation.dart';

part 'parquet_input_serialization.g.dart';

@JsonSerializable(fieldRename: FieldRename.pascal)
class ParquetInputSerialization {
  ParquetInputSerialization();
  factory ParquetInputSerialization.fromJson(Map<String, dynamic> json) =>
      _$ParquetInputSerializationFromJson(json);

  Map<String, dynamic> toJson() => _$ParquetInputSerializationToJson(this);
}
