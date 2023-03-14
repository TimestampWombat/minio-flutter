// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'versioning_configuration.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

VersioningConfiguration _$VersioningConfigurationFromJson(
        Map<String, dynamic> json) =>
    VersioningConfiguration(
      json['Status'] as String,
      json['MFADelete'] as String?,
    );

Map<String, dynamic> _$VersioningConfigurationToJson(
        VersioningConfiguration instance) =>
    <String, dynamic>{
      'Status': instance.statusK,
      'MFADelete': instance.mfaDelete,
    };
