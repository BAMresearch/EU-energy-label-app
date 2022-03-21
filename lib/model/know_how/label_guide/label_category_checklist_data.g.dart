// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'label_category_checklist_data.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

LabelCategoryChecklistData _$LabelCategoryChecklistDataFromJson(Map<String, dynamic> json) =>
    LabelCategoryChecklistData(
      id: json['field_id'] as int?,
      title: json['field_title'] as String?,
      graphicPath: json['field_graphics'] as String?,
      orderIndex: json['field_order'] as int?,
      checklists: (json['label_category_checklists'] as List<dynamic>?)
          ?.map((e) => LabelCategoryChecklist.fromJson(e as Map<String, dynamic>))
          .toList(),
      introText: json['field_intro'] as String?,
      informationText: json['field_information_text'] as String?,
      informationTitle: json['field_information_title'] as String?,
    );

Map<String, dynamic> _$LabelCategoryChecklistDataToJson(LabelCategoryChecklistData instance) => <String, dynamic>{
      'field_id': instance.id,
      'field_title': instance.title,
      'field_graphics': instance.graphicPath,
      'field_intro': instance.introText,
      'field_order': instance.orderIndex,
      'label_category_checklists': instance.checklists,
      'field_information_title': instance.informationTitle,
      'field_information_text': instance.informationText,
    };
