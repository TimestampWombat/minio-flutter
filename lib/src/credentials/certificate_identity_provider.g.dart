// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'certificate_identity_provider.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

CertificateIdentityResponse _$CertificateIdentityResponseFromJson(
        Map<String, dynamic> json) =>
    CertificateIdentityResponse(
      Credentials.fromJson(json['Credentials'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$CertificateIdentityResponseToJson(
        CertificateIdentityResponse instance) =>
    <String, dynamic>{
      'Credentials': instance.credentials,
    };
