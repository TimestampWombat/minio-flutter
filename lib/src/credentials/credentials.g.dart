// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'credentials.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Credentials _$CredentialsFromJson(Map<String, dynamic> json) => Credentials(
      json['AccessKeyId'] as String,
      json['SecretAccessKey'] as String,
      json['SessionToken'] as String?,
      ResponseDate.fromJson(json['Expiration'] as String?),
    );

Map<String, dynamic> _$CredentialsToJson(Credentials instance) {
  final val = <String, dynamic>{
    'AccessKeyId': instance.accessKey,
    'SecretAccessKey': instance.secretKey,
  };

  void writeNotNull(String key, dynamic value) {
    if (value != null) {
      val[key] = value;
    }
  }

  writeNotNull('SessionToken', instance.sessionToken);
  writeNotNull('Expiration', ResponseDate.toJson(instance.expiration));
  return val;
}
