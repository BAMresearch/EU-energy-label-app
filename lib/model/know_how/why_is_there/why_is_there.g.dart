// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'why_is_there.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

WhyIsThere _$WhyIsThereFromJson(Map<String, dynamic> json) {
  return WhyIsThere(
    entries: (json['why_is_there_entries'] as List)
        ?.map((e) => e == null
            ? null
            : WhyIsThereEntry.fromJson(e as Map<String, dynamic>))
        ?.toList(),
  );
}

Map<String, dynamic> _$WhyIsThereToJson(WhyIsThere instance) =>
    <String, dynamic>{
      'why_is_there_entries': instance.entries,
    };