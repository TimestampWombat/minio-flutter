import 'package:json_annotation/json_annotation.dart';

part 'legal_hold.g.dart';

// @Namespace(reference = "http://s3.amazonaws.com/doc/2006-03-01/")
@JsonSerializable(fieldRename: FieldRename.pascal)
class LegalHold {
  // @Element(name = "Status", required = false)
  @JsonKey(name: 'Status')
  String? statusName;

  LegalHold(this.statusName);

  /// Constructs a LegalHold object with given status.
  LegalHold.bool(bool status) {
    statusName = status ? "ON" : "OFF";
  }

  /// Indicates whether the specified object has a Legal Hold in place or not.
  bool status() {
    return statusName == "ON";
  }

  factory LegalHold.fromJson(Map<String, dynamic> json) =>
      _$LegalHoldFromJson(json);
  Map<String, dynamic> toJson() => _$LegalHoldToJson(this);
}
