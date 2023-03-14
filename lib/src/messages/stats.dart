// @Root(name = "Stats", strict = false)
// @Namespace(reference = "http://s3.amazonaws.com/doc/2006-03-01/")

import 'package:json_annotation/json_annotation.dart';

part 'stats.g.dart';

@JsonSerializable(fieldRename: FieldRename.pascal)
class Stats {
  final int bytesScanned;

  final int bytesProcessed;

  final int bytesReturned;

  Stats([this.bytesScanned = -1, this.bytesProcessed = -1, this.bytesReturned = -1]);

  factory Stats.fromJson(Map<String, dynamic> json) => _$StatsFromJson(json);

  Map<String, dynamic> toJson() => _$StatsToJson(this);
}
