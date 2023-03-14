// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'encryption_configuration.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

EncryptionConfiguration _$EncryptionConfigurationFromJson(
        Map<String, dynamic> json) =>
    EncryptionConfiguration(
      json['ReplicaKmsKeyID'] as String,
    );

Map<String, dynamic> _$EncryptionConfigurationToJson(
        EncryptionConfiguration instance) =>
    <String, dynamic>{
      'ReplicaKmsKeyID': instance.replicaKmsKeyID,
    };
