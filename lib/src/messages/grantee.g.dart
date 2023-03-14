// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'grantee.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Grantee _$GranteeFromJson(Map<String, dynamic> json) => Grantee(
      displayName: json['DisplayName'] as String?,
      emailAddress: json['EmailAddress'] as String?,
      id: json['ID'] as String?,
      type: $enumDecode(_$GranteeTypeEnumMap, json['Type']),
      uri: json['URI'] as String?,
    );

Map<String, dynamic> _$GranteeToJson(Grantee instance) => <String, dynamic>{
      'DisplayName': instance.displayName,
      'EmailAddress': instance.emailAddress,
      'ID': instance.id,
      'Type': _$GranteeTypeEnumMap[instance.type]!,
      'URI': instance.uri,
    };

const _$GranteeTypeEnumMap = {
  GranteeType.CANONICAL_USER: 'CANONICAL_USER',
  GranteeType.AMAZON_CUSTOMER_BY_EMAIL: 'AMAZON_CUSTOMER_BY_EMAIL',
  GranteeType.GROUP: 'GROUP',
};
