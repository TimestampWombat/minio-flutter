// @Root(name = "DeleteMarker", strict = false)

import 'package:json_annotation/json_annotation.dart';

import 'item.dart';

@JsonSerializable()
class DeleteMarker extends Item {
  DeleteMarker(String prefix) : super.prefix(prefix);

  factory DeleteMarker.fromJson(Map<String, dynamic> json) =>
      _$DeleteMarkerFromJson(json);

  Map<String, dynamic> toJson() => _$DeleteMarkerToJson(this);
}
