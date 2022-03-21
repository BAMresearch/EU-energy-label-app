// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'checklist_entry.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ChecklistEntry _$ChecklistEntryFromJson(Map<String, dynamic> json) => ChecklistEntry(
      id: json['field_id'] as int?,
      text: json['text'] as String?,
      checked: json['checked'] as bool? ?? false,
    );

Map<String, dynamic> _$ChecklistEntryToJson(ChecklistEntry instance) => <String, dynamic>{
      'field_id': instance.id,
      'text': instance.text,
      'checked': instance.checked,
    };
