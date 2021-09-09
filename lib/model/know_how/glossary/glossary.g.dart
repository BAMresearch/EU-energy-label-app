// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'glossary.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Glossary _$GlossaryFromJson(Map<String, dynamic> json) {
  return Glossary(
    glossaryEntries: (json['glossary-entries'] as List<dynamic>?)
        ?.map((e) => GlossaryEntry.fromJson(e as Map<String, dynamic>))
        .toList(),
  );
}

Map<String, dynamic> _$GlossaryToJson(Glossary instance) => <String, dynamic>{
      'glossary-entries': instance.glossaryEntries,
    };
