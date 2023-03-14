// @Root(name = "GlacierJobParameters")
// @edu.umd.cs.findbugs.annotations.SuppressFBWarnings(value = "URF_UNREAD_FIELD")

import 'package:json_annotation/json_annotation.dart';

import 'tier.dart';

part 'glacier_job_parameters.g.dart';

@JsonSerializable(fieldRename: FieldRename.pascal)
class GlacierJobParameters {
  final Tier tier;

  GlacierJobParameters(this.tier);

  factory GlacierJobParameters.fromJson(Map<String, dynamic> json) =>
      _$GlacierJobParametersFromJson(json);

  Map<String, dynamic> toJson() => _$GlacierJobParametersToJson(this);
}
