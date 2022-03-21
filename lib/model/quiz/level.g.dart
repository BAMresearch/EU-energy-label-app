// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'level.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Level _$LevelFromJson(Map<String, dynamic> json) => Level(
      name: json['title'] as String?,
      questions:
          (json['questions'] as List<dynamic>?)?.map((e) => Question.fromJson(e as Map<String, dynamic>)).toList(),
      score: json['score'] == null ? null : Score.fromJson(json['score'] as Map<String, dynamic>),
      icon: json['icon-svg'] as String?,
    );

Map<String, dynamic> _$LevelToJson(Level instance) => <String, dynamic>{
      'title': instance.name,
      'icon-svg': instance.icon,
      'questions': instance.questions,
      'score': instance.score,
    };
