import 'package:json_annotation/json_annotation.dart';

part 'tag.g.dart';

@JsonSerializable(fieldRename: FieldRename.pascal)
class Tag {
  final String key;

  final String value;

  Tag(this.key, this.value) {
    if (key.isEmpty) {
      throw ArgumentError("Key must not be empty");
    }
  }
  factory Tag.fromJson(Map<String, dynamic> json) => _$TagFromJson(json);
  Map<String, dynamic> toJson() => _$TagToJson(this);
}
