// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'regulation_data.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

RegulationData _$RegulationDataFromJson(Map<String, dynamic> json) {
  return RegulationData(
    title: json['title'] as String,
    description: json['description'] as String,
    regulations: (json['regulations'] as List)
        ?.map((e) =>
            e == null ? null : Regulation.fromJson(e as Map<String, dynamic>))
        ?.toList(),
  );
}

Map<String, dynamic> _$RegulationDataToJson(RegulationData instance) =>
    <String, dynamic>{
      'title': instance.title,
      'description': instance.description,
      'regulations': instance.regulations,
    };
