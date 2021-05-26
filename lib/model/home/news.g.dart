// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'news.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

News _$NewsFromJson(Map<String, dynamic> json) {
  return News(
    title: json['title'] as String,
    description: json['description'] as String,
    language: json['language'] as String,
    publicationDate: json['pubDate'] == null
        ? null
        : DateTime.parse(json['pubDate'] as String),
    markedRead: json['markedRead'] as bool,
  );
}

Map<String, dynamic> _$NewsToJson(News instance) => <String, dynamic>{
      'title': instance.title,
      'description': instance.description,
      'language': instance.language,
      'pubDate': instance.publicationDate?.toIso8601String(),
      'markedRead': instance.markedRead,
    };
