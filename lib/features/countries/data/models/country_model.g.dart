// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'country_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$CountryModelImpl _$$CountryModelImplFromJson(Map<String, dynamic> json) =>
    _$CountryModelImpl(
      name: json['name'] as String,
      capital: json['capital'] as String?,
      continent: json['continent'] as String?,
      emoji: json['emoji'] as String?,
    );

Map<String, dynamic> _$$CountryModelImplToJson(_$CountryModelImpl instance) =>
    <String, dynamic>{
      'name': instance.name,
      'capital': instance.capital,
      'continent': instance.continent,
      'emoji': instance.emoji,
    };
