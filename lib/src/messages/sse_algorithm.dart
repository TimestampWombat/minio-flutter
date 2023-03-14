// @Root(name = "SSEAlgorithm")
// @Convert(SseAlgorithm.SseAlgorithmConverter.class)
import 'package:json_annotation/json_annotation.dart';

enum SseAlgorithm {
  @JsonValue("AES256")
  AES256,
  @JsonValue("aws:kms")
  AWS_KMS;
}
