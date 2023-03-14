// @Root(name = "ServerSideEncryptionConfiguration")
// @Namespace(reference = "http://s3.amazonaws.com/doc/2006-03-01/")
// @edu.umd.cs.findbugs.annotations.SuppressFBWarnings(value = "URF_UNREAD_FIELD")
import 'package:json_annotation/json_annotation.dart';

import 'sse_algorithm.dart';
import 'sse_configuration_rule.dart';

part 'sse_configuration.g.dart';

@JsonSerializable(fieldRename: FieldRename.pascal)
class SseConfiguration {
  // @Element(name = "Rule", required = false)
  final SseConfigurationRule? rule;

  SseConfiguration(this.rule);

  static SseConfiguration newConfigWithSseS3Rule() {
    return SseConfiguration(SseConfigurationRule(SseAlgorithm.AES256, null));
  }

  static SseConfiguration newConfigWithSseKmsRule(String? kmsMasterKeyId) {
    return SseConfiguration(
        SseConfigurationRule(SseAlgorithm.AWS_KMS, kmsMasterKeyId));
  }

  factory SseConfiguration.fromJson(Map<String, dynamic> json) =>
      _$SseConfigurationFromJson(json);

  Map<String, dynamic> toJson() => _$SseConfigurationToJson(this);
}
