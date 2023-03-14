// @Root(name = "Rule")
// @Namespace(reference = "http://s3.amazonaws.com/doc/2006-03-01/")
// @edu.umd.cs.findbugs.annotations.SuppressFBWarnings(value = "URF_UNREAD_FIELD")
import 'package:json_annotation/json_annotation.dart';

import 'package:meta/meta.dart';

import 'sse_algorithm.dart';

part 'sse_configuration_rule.g.dart';

@JsonSerializable(fieldRename: FieldRename.pascal)
class SseConfigurationRule {
  // @Path(value = "ApplyServerSideEncryptionByDefault")
  @JsonKey(name: "KMSMasterKeyID")
  final String? kmsMasterKeyId;

  // @Path(value = "ApplyServerSideEncryptionByDefault")
  @JsonKey(name: "SSEAlgorithm")
  final SseAlgorithm sseAlgorithm;

  /// Constructs server-side encryption configuration rule.
  SseConfigurationRule(this.sseAlgorithm, this.kmsMasterKeyId);
 
  factory SseConfigurationRule.fromJson(Map<String, dynamic> json) =>
      _$SseConfigurationRuleFromJson(json);

  Map<String, dynamic> toJson() => _$SseConfigurationRuleToJson(this);
}
