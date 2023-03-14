// @Root(name = "Contents", strict = false)

import 'package:json_annotation/json_annotation.dart';

import 'item.dart';

part 'contents.g.dart';

@JsonSerializable()
class Contents extends Item {
  Contents(String prefix) : super.prefix(prefix);
  
  factory Contents.fromJson(Map<String, dynamic> json) =>
      _$ContentsFromJson(json);

  Map<String, dynamic> toJson() => _$ContentsToJson(this);
}
