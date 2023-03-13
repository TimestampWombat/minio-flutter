// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'client_grants_provider.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ClientGrantsResponse _$ClientGrantsResponseFromJson(
        Map<String, dynamic> json) =>
    ClientGrantsResponse(
      Credentials.fromJson(json['credentials'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$ClientGrantsResponseToJson(
        ClientGrantsResponse instance) =>
    <String, dynamic>{
      'credentials': instance.credentials,
    };
