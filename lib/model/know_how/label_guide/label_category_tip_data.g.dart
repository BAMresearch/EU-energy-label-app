// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'label_category_tip_data.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

LabelCategoryTipData _$LabelCategoryTipDataFromJson(Map<String, dynamic> json) => LabelCategoryTipData(
      title: json['field_title'] as String?,
      graphicPath: json['field_graphics'] as String?,
      labelTips:
          (json['label_tips'] as List<dynamic>?)?.map((e) => LabelTip.fromJson(e as Map<String, dynamic>)).toList(),
    );

Map<String, dynamic> _$LabelCategoryTipDataToJson(LabelCategoryTipData instance) => <String, dynamic>{
      'field_title': instance.title,
      'field_graphics': instance.graphicPath,
      'label_tips': instance.labelTips,
    };
