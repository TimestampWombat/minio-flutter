// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'and_operator.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

AndOperator _$AndOperatorFromJson(Map<String, dynamic> json) => AndOperator(
      json['Prefix'] as String?,
      (json['Tags'] as Map<String, dynamic>?)?.map(
        (k, e) => MapEntry(k, e as String),
      ),
    );

Map<String, dynamic> _$AndOperatorToJson(AndOperator instance) =>
    <String, dynamic>{
      'Prefix': instance.prefix,
      'Tags': instance.tags,
    };
