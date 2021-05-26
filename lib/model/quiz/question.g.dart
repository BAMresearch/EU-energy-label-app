// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'question.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Question _$QuestionFromJson(Map<String, dynamic> json) {
  return Question(
    viewType: json['view-type'] as String,
    title: json['title'] as String,
    explanation: json['explanation'] as String,
    answers: (json['answers'] as List)
        ?.map((e) =>
            e == null ? null : Answer.fromJson(e as Map<String, dynamic>))
        ?.toList(),
  );
}

Map<String, dynamic> _$QuestionToJson(Question instance) => <String, dynamic>{
      'view-type': instance.viewType,
      'title': instance.title,
      'explanation': instance.explanation,
      'answers': instance.answers,
    };
