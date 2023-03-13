// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'i_am_aws_provider.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

EcsCredentials _$EcsCredentialsFromJson(Map<String, dynamic> json) =>
    EcsCredentials(
      json['AccessKeyID'] as String,
      json['SecretAccessKey'] as String,
      json['Token'] as String,
      ResponseDate.fromString(json['Expiration'] as String?),
      json['Code'] as String?,
      json['Message'] as String?,
    );

Map<String, dynamic> _$EcsCredentialsToJson(EcsCredentials instance) =>
    <String, dynamic>{
      'AccessKeyID': instance.accessKey,
      'SecretAccessKey': instance.secretKey,
      'Token': instance.sessionToken,
      'Expiration': ResponseDate.toJson(instance.expiration),
      'Code': instance.code,
      'Message': instance.message,
    };
