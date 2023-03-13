// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'jwt.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Jwt _$JwtFromJson(Map<String, dynamic> json) => Jwt(
      json['access_token'] as String,
      json['expires_in'] as int,
    );

Map<String, dynamic> _$JwtToJson(Jwt instance) => <String, dynamic>{
      'access_token': instance.token,
      'expires_in': instance.expiry,
    };
