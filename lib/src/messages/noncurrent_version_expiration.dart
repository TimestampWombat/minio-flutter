// @Root(name = "NoncurrentVersionExpiration")

import 'package:json_annotation/json_annotation.dart';

part 'noncurrent_version_expiration.g.dart';

@JsonSerializable(fieldRename: FieldRename.pascal)
class NoncurrentVersionExpiration {
  // @Element(name = "NoncurrentDays")
  final int noncurrentDays;

  NoncurrentVersionExpiration(this.noncurrentDays);

  factory NoncurrentVersionExpiration.fromJson(Map<String, dynamic> json) =>
      _$NoncurrentVersionExpirationFromJson(json);

  Map<String, dynamic> toJson() => _$NoncurrentVersionExpirationToJson(this);
}
