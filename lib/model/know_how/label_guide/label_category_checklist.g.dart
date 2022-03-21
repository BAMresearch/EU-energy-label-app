// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'label_category_checklist.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

LabelCategoryChecklist _$LabelCategoryChecklistFromJson(Map<String, dynamic> json) => LabelCategoryChecklist(
      checklistEntries: (json['field_checklist_entries'] as List<dynamic>?)
          ?.map((e) => ChecklistEntry.fromJson(e as Map<String, dynamic>))
          .toList(),
      id: json['field_id'] as int?,
      title: json['field_title'] as String?,
    );

Map<String, dynamic> _$LabelCategoryChecklistToJson(LabelCategoryChecklist instance) => <String, dynamic>{
      'field_id': instance.id,
      'field_title': instance.title,
      'field_checklist_entries': instance.checklistEntries,
    };
