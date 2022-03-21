// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'answer.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Answer _$AnswerFromJson(Map<String, dynamic> json) => Answer(
      title: json['title'] as String?,
      isCorrect: json['correct'] as bool?,
    );

Map<String, dynamic> _$AnswerToJson(Answer instance) => <String, dynamic>{
      'title': instance.title,
      'correct': instance.isCorrect,
    };
