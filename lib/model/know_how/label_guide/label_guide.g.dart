// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'label_guide.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

LabelGuide _$LabelGuideFromJson(Map<String, dynamic> json) {
  return LabelGuide(
    title: json['field_title'] as String,
    labelCategories: (json['label_categories'] as List)
        ?.map((e) => e == null
            ? null
            : LabelCategory.fromJson(e as Map<String, dynamic>))
        ?.toList(),
  );
}

Map<String, dynamic> _$LabelGuideToJson(LabelGuide instance) =>
    <String, dynamic>{
      'field_title': instance.title,
      'label_categories': instance.labelCategories,
    };
