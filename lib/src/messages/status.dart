// @Root(name = "Status")
// @Convert(Status.StatusConverter.class)

import 'package:json_annotation/json_annotation.dart';

enum Status {
  @JsonValue("Disabled")
  DISABLED,
  @JsonValue("Enabled")
  ENABLED;
}
