// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'glacier_job_parameters.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

GlacierJobParameters _$GlacierJobParametersFromJson(
        Map<String, dynamic> json) =>
    GlacierJobParameters(
      $enumDecode(_$TierEnumMap, json['Tier']),
    );

Map<String, dynamic> _$GlacierJobParametersToJson(
        GlacierJobParameters instance) =>
    <String, dynamic>{
      'Tier': _$TierEnumMap[instance.tier]!,
    };

const _$TierEnumMap = {
  Tier.STANDARD: 'STANDARD',
  Tier.BULK: 'BULK',
  Tier.EXPEDITED: 'EXPEDITED',
};
