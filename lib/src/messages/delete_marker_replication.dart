// @Root(name = "DeleteMarkerReplication")
import 'package:json_annotation/json_annotation.dart';

import 'status.dart';

part 'delete_marker_replication.g.dart';

@JsonSerializable(fieldRename: FieldRename.pascal)
class DeleteMarkerReplication {
  final Status status;

  /// Constructs server-side encryption configuration rule.
  DeleteMarkerReplication([this.status = Status.DISABLED]);

  factory DeleteMarkerReplication.fromJson(Map<String, dynamic> json) =>
      _$DeleteMarkerReplicationFromJson(json);

  Map<String, dynamic> toJson() => _$DeleteMarkerReplicationToJson(this);
}
