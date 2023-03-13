// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'ldap_identity_provider.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

LdapIdentityResponse _$LdapIdentityResponseFromJson(
        Map<String, dynamic> json) =>
    LdapIdentityResponse(
      Credentials.fromJson(json['Credentials'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$LdapIdentityResponseToJson(
        LdapIdentityResponse instance) =>
    <String, dynamic>{
      'Credentials': instance.credentials,
    };
