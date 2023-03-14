// @Root(name = "CreateBucketConfiguration")
// @Namespace(reference = "http://s3.amazonaws.com/doc/2006-03-01/")
// @edu.umd.cs.findbugs.annotations.SuppressFBWarnings(value = "URF_UNREAD_FIELD")

import 'package:json_annotation/json_annotation.dart';

part 'create_bucket_configuration.g.dart';
@JsonSerializable(fieldRename: FieldRename.pascal)
class CreateBucketConfiguration {
  final String locationConstraint;

  CreateBucketConfiguration(this.locationConstraint);

  factory CreateBucketConfiguration.fromJson(Map<String, dynamic> json) =>
      _$CreateBucketConfigurationFromJson(json);

  Map<String, dynamic> toJson() => _$CreateBucketConfigurationToJson(this);
}
