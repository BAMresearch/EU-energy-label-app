// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'label_category.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

LabelCategory _$LabelCategoryFromJson(Map<String, dynamic> json) {
  return LabelCategory(
    id: json['field_id'] as int?,
    productType: json['field_producttype'] as String?,
    description: json['field_description'] as String?,
    backgroundColorHex: json['field_background_color_hex'] as String?,
    textColorHex: json['field_text_color_hex'] as String?,
    graphicPath: json['field_graphics'] as String?,
    orderIndex: json['field_order'] as int?,
    checklistData: json['label_category_checklist_data'] == null
        ? null
        : LabelCategoryChecklistData.fromJson(
            json['label_category_checklist_data'] as Map<String, dynamic>),
    tipData: json['label_category_tips'] == null
        ? null
        : LabelCategoryTipData.fromJson(
            json['label_category_tips'] as Map<String, dynamic>),
    guideData: json['label_category_guide'] == null
        ? null
        : LabelCategoryGuideData.fromJson(
            json['label_category_guide'] as Map<String, dynamic>),
    lightAdviser: json['label_category_light_adviser'] == null
        ? null
        : LabelCategoryLightAdviser.fromJson(
            json['label_category_light_adviser'] as Map<String, dynamic>),
    visible: json['visible'] as bool?,
    favoriteOnly: json['favorite_only'] as bool?,
  );
}

Map<String, dynamic> _$LabelCategoryToJson(LabelCategory instance) =>
    <String, dynamic>{
      'field_id': instance.id,
      'field_producttype': instance.productType,
      'field_description': instance.description,
      'field_background_color_hex': instance.backgroundColorHex,
      'field_text_color_hex': instance.textColorHex,
      'field_graphics': instance.graphicPath,
      'field_order': instance.orderIndex,
      'label_category_checklist_data': instance.checklistData,
      'label_category_tips': instance.tipData,
      'label_category_guide': instance.guideData,
      'label_category_light_adviser': instance.lightAdviser,
      'visible': instance.visible,
      'favorite_only': instance.favoriteOnly,
    };
