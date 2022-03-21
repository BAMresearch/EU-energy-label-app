// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'why_is_there_entry.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

WhyIsThereEntry _$WhyIsThereEntryFromJson(Map<String, dynamic> json) => WhyIsThereEntry(
      title: json['field_title'] as String?,
      orderIndex: json['field_order'] as int?,
      text: json['field_text'] as String?,
      textSemantic: json['field_text_semantic'] as String?,
      imageUri: json['field_image'] as String?,
      videoUri: json['field_video'] as String?,
    );

Map<String, dynamic> _$WhyIsThereEntryToJson(WhyIsThereEntry instance) => <String, dynamic>{
      'field_title': instance.title,
      'field_text': instance.text,
      'field_text_semantic': instance.textSemantic,
      'field_image': instance.imageUri,
      'field_video': instance.videoUri,
      'field_order': instance.orderIndex,
    };
