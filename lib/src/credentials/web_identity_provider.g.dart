// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'web_identity_provider.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

WebIdentityResponse _$WebIdentityResponseFromJson(Map<String, dynamic> json) =>
    WebIdentityResponse(
      Credentials.fromJson(json['credentials'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$WebIdentityResponseToJson(
        WebIdentityResponse instance) =>
    <String, dynamic>{
      'credentials': instance.credentials,
    };
