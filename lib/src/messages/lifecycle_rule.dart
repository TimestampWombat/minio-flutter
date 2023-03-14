// @Root(name = "Rule")

import 'package:json_annotation/json_annotation.dart';

import 'abort_incomplete_multipart_upload.dart';
import 'expiration.dart';
import 'noncurrent_version_expiration.dart';
import 'noncurrent_version_transition.dart';
import 'rule_filter.dart';
import 'status.dart';
import 'transition.dart';

part 'lifecycle_rule.g.dart';

@JsonSerializable(fieldRename: FieldRename.pascal)
class LifecycleRule {
  // @Element(name = "AbortIncompleteMultipartUpload", required = false)
  final AbortIncompleteMultipartUpload? abortIncompleteMultipartUpload;

  // @Element(name = "Expiration", required = false)
  final Expiration? expiration;

  // @Element(name = "Filter", required = false)
  final RuleFilter filter;

  @JsonKey(name: "ID")
  late final String? id;

  // @Element(name = "NoncurrentVersionExpiration", required = false)
  final NoncurrentVersionExpiration? noncurrentVersionExpiration;

  // @Element(name = "NoncurrentVersionTransition", required = false)
  final NoncurrentVersionTransition? noncurrentVersionTransition;

  // @Element(name = "Status")
  final Status status;

  // @Element(name = "Transition", required = false)
  final Transition? transition;

  /// Constructs server-side encryption configuration rule.
  LifecycleRule(
      this.status,
      this.abortIncompleteMultipartUpload,
      this.expiration,
      this.filter,
      String? id,
      this.noncurrentVersionExpiration,
      this.noncurrentVersionTransition,
      this.transition) {
    if (abortIncompleteMultipartUpload == null &&
        expiration == null &&
        noncurrentVersionExpiration == null &&
        noncurrentVersionTransition == null &&
        transition == null) {
      throw ArgumentError(
          "At least one of action (AbortIncompleteMultipartUpload, Expiration, NoncurrentVersionExpiration, NoncurrentVersionTransition or Transition) must be specified in a rule");
    }

    String? idStr = id;
    if (idStr != null) {
      idStr = idStr.trim();
      if (idStr.isEmpty) throw ArgumentError("ID must be non-empty string");
      if (idStr.length > 255) {
        throw ArgumentError("ID must be exceed 255 characters");
      }
    }
    id = idStr;
  }

  factory LifecycleRule.fromJson(Map<String, dynamic> json) =>
      _$LifecycleRuleFromJson(json);

  Map<String, dynamic> toJson() => _$LifecycleRuleToJson(this);
}
