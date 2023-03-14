// @Root(name = "Retention", strict = false)
// @Namespace(reference = "http://s3.amazonaws.com/doc/2006-03-01/")

import 'package:json_annotation/json_annotation.dart';

import 'response_date.dart';
import 'retention_mode.dart';

part 'retention.g.dart';

@JsonSerializable(fieldRename: FieldRename.pascal)
class Retention {
  // @Element(name = "Mode", required = false)
  RetentionMode? mode;

  // @Element(name = "RetainUntilDate", required = false)
  @JsonKey(fromJson: ResponseDate.fromJson, toJson: ResponseDate.toJson)
  ResponseDate? retainUntilDate;

  Retention(this.mode, this.retainUntilDate);

  /// Constructs a Retention object with given retention until date and mode.
  Retention.date(this.mode, DateTime? retainUntilDate) {
    if (mode == null) {
      throw ArgumentError("null mode is not allowed");
    }

    if (retainUntilDate == null) {
      throw ArgumentError("null retainUntilDate is not allowed");
    }
    this.retainUntilDate = ResponseDate(retainUntilDate);
  }

  factory Retention.fromJson(Map<String, dynamic> json) =>
      _$RetentionFromJson(json);

  Map<String, dynamic> toJson() => _$RetentionToJson(this);
}
