// @Root(name = "CannedAcl")
// @Convert(CannedAcl.CannedAclConverter.class)

import 'package:json_annotation/json_annotation.dart';

@JsonEnum()
enum CannedAcl {
  @JsonValue("private")
  PRIVATE,
  @JsonValue("public-read")
  PUBLIC_READ,
  @JsonValue("public-read-write")
  PUBLIC_READ_WRITE,
  @JsonValue("authenticated-read")
  AUTHENTICATED_READ,
  @JsonValue("aws-exec-read")
  AWS_EXEC_READ,
  @JsonValue("bucket-owner-read")
  BUCKET_OWNER_READ,
  @JsonValue("bucket-owner-full-control")
  BUCKET_OWNER_FULL_CONTROL;
}
