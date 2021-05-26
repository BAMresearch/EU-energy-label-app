// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'score.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Score _$ScoreFromJson(Map<String, dynamic> json) {
  return Score(
    positive: json['positive-response'] as String,
    negative: json['negative-response'] as String,
    minPositiveScore: json['min-positive-score'] as int,
  );
}

Map<String, dynamic> _$ScoreToJson(Score instance) => <String, dynamic>{
      'positive-response': instance.positive,
      'negative-response': instance.negative,
      'min-positive-score': instance.minPositiveScore,
    };
