// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'label_category_guide_data.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

LabelCategoryGuideData _$LabelCategoryGuideDataFromJson(
    Map<String, dynamic> json) {
  return LabelCategoryGuideData(
    title: json['field_title'] as String,
    introText: json['field_intro'] as String,
    outroText: json['field_outro'] as String,
    informationTitle: json['field_information_title'] as String,
    informationText: json['field_information_text'] as String,
    fridgeLeftSideInfoZones: (json['fridge_left_info_zones'] as List)
        ?.map((e) => e == null
            ? null
            : FridgeInfoZoneData.fromJson(e as Map<String, dynamic>))
        ?.toList(),
    fridgeRightSideInfoZones: (json['fridge_right_info_zones'] as List)
        ?.map((e) => e == null
            ? null
            : FridgeInfoZoneData.fromJson(e as Map<String, dynamic>))
        ?.toList(),
  );
}

Map<String, dynamic> _$LabelCategoryGuideDataToJson(
        LabelCategoryGuideData instance) =>
    <String, dynamic>{
      'field_title': instance.title,
      'field_intro': instance.introText,
      'field_outro': instance.outroText,
      'field_information_title': instance.informationTitle,
      'field_information_text': instance.informationText,
      'fridge_left_info_zones': instance.fridgeLeftSideInfoZones,
      'fridge_right_info_zones': instance.fridgeRightSideInfoZones,
    };

FridgeInfoZoneData _$FridgeInfoZoneDataFromJson(Map<String, dynamic> json) {
  return FridgeInfoZoneData(
    description: json['field_zone'] as String,
    tooltipHtml: json['field_tooltip'] as String,
  );
}

Map<String, dynamic> _$FridgeInfoZoneDataToJson(FridgeInfoZoneData instance) =>
    <String, dynamic>{
      'field_zone': instance.description,
      'field_tooltip': instance.tooltipHtml,
    };
