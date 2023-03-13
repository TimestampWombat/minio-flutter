// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'minio_client_config_provider.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

McConfig _$McConfigFromJson(Map<String, dynamic> json) => McConfig(
      (json['hosts'] as Map<String, dynamic>).map(
        (k, e) => MapEntry(k, Map<String, String>.from(e as Map)),
      ),
    );

Map<String, dynamic> _$McConfigToJson(McConfig instance) => <String, dynamic>{
      'hosts': instance.hosts,
    };
