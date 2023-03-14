// @Root(name = "ExistingObjectReplication")
import 'package:json_annotation/json_annotation.dart';

import 'status.dart';

part 'existing_object_replication.g.dart';

@JsonSerializable(fieldRename: FieldRename.pascal)
class ExistingObjectReplication {
  final Status status;

  ExistingObjectReplication(this.status);

  factory ExistingObjectReplication.fromJson(Map<String, dynamic> json) =>
      _$ExistingObjectReplicationFromJson(json);

  Map<String, dynamic> toJson() => _$ExistingObjectReplicationToJson(this);
}
