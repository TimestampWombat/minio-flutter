// @Root(name = "VersioningConfiguration", strict = false)
// @Namespace(reference = "http://s3.amazonaws.com/doc/2006-03-01/")

import 'package:json_annotation/json_annotation.dart';

part 'versioning_configuration.g.dart';

@JsonSerializable(fieldRename: FieldRename.pascal)
class VersioningConfiguration {
  @JsonKey(name: "Status")
  late final String statusK;

  @JsonKey(name: "MFADelete")
  late final String? mfaDelete;

  VersioningConfiguration(this.statusK, this.mfaDelete);

  /// Constructs a VersioningConfiguration object with given status.
  VersioningConfiguration.status(Status status, bool? mfaDelete) {
    if (status == Status.OFF) {
      throw ArgumentError("Status must be ENABLED or SUSPENDED");
    }
    statusK = status.toString();

    if (mfaDelete != null) {
      this.mfaDelete = mfaDelete ? "Enabled" : "Disabled";
    }
  }

  Status status() {
    return Status.fromString(statusK);
  }

  bool? isMfaDeleteEnabled() {
    bool? flag = (mfaDelete != null) ? "Enabled" == mfaDelete : null;
    return flag;
  }
}

enum Status {
  OFF(""),
  ENABLED("Enabled"),
  SUSPENDED("Suspended");

  final String value;

  const Status(this.value);

  @override
  String toString() {
    return value;
  }

  static Status fromString(String statusString) {
    if ("Enabled" == statusString) {
      return ENABLED;
    }

    if ("Suspended" == statusString) {
      return SUSPENDED;
    }

    return OFF;
  }
}
