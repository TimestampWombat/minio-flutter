// @Root(name = "DeleteReplication")

import 'package:json_annotation/json_annotation.dart';

import 'status.dart';

part 'delete_replication.g.dart';

@JsonSerializable(fieldRename: FieldRename.pascal)
class DeleteReplication {
  final Status status;

  DeleteReplication([this.status = Status.DISABLED]);

  factory DeleteReplication.fromJson(Map<String, dynamic> json) =>
      _$DeleteReplicationFromJson(json);

  Map<String, dynamic> toJson() => _$DeleteReplicationToJson(this);
}
