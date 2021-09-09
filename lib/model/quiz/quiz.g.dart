// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'quiz.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Quiz _$QuizFromJson(Map<String, dynamic> json) {
  return Quiz(
    title: json['title'] as String?,
    description: json['description'] as String?,
    levels: (json['levels'] as List<dynamic>?)
        ?.map((e) => Level.fromJson(e as Map<String, dynamic>))
        .toList(),
  );
}

Map<String, dynamic> _$QuizToJson(Quiz instance) => <String, dynamic>{
      'title': instance.title,
      'description': instance.description,
      'levels': instance.levels,
    };
