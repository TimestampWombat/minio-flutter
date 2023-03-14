// @Root(name = "EncryptionConfiguration")

import 'package:json_annotation/json_annotation.dart';

part 'encryption_configuration.g.dart';
@JsonSerializable(fieldRename: FieldRename.pascal)
class EncryptionConfiguration {
  // @Element(name = "ReplicaKmsKeyID", required = false)
  final String replicaKmsKeyID;

  EncryptionConfiguration(this.replicaKmsKeyID);

  factory EncryptionConfiguration.fromJson(Map<String, dynamic> json) =>
      _$EncryptionConfigurationFromJson(json);

  Map<String, dynamic> toJson() => _$EncryptionConfigurationToJson(this);
}
