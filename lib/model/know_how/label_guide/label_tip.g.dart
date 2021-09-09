// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'label_tip.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

LabelTip _$LabelTipFromJson(Map<String, dynamic> json) {
  return LabelTip(
    id: json['field_id'] as int?,
    informationTitle: json['field_information_title'] as String?,
    informationText: json['field_information_text'] as String?,
    title: json['field_title'] as String?,
    orderIndex: json['field_order'] as int?,
    description: json['field_description'] as String?,
    viewType: _$enumDecodeNullable(
        _$LabelTipViewTypeEnumMap, json['field_view_type']),
    labelTipContentImages: (json['label_tip_content_images'] as List<dynamic>?)
        ?.map((e) => LabelTipContentImage.fromJson(e as Map<String, dynamic>))
        .toList(),
    graphicData: json['field_graphics'] as String?,
    videoPath: json['field_video'] as String?,
  );
}

Map<String, dynamic> _$LabelTipToJson(LabelTip instance) => <String, dynamic>{
      'field_id': instance.id,
      'field_information_title': instance.informationTitle,
      'field_information_text': instance.informationText,
      'field_title': instance.title,
      'field_description': instance.description,
      'field_order': instance.orderIndex,
      'field_view_type': _$LabelTipViewTypeEnumMap[instance.viewType],
      'field_graphics': instance.graphicData,
      'field_video': instance.videoPath,
      'label_tip_content_images': instance.labelTipContentImages,
    };

K _$enumDecode<K, V>(
  Map<K, V> enumValues,
  Object? source, {
  K? unknownValue,
}) {
  if (source == null) {
    throw ArgumentError(
      'A value must be provided. Supported values: '
      '${enumValues.values.join(', ')}',
    );
  }

  return enumValues.entries.singleWhere(
    (e) => e.value == source,
    orElse: () {
      if (unknownValue == null) {
        throw ArgumentError(
          '`$source` is not one of the supported values: '
          '${enumValues.values.join(', ')}',
        );
      }
      return MapEntry(unknownValue, enumValues.values.first);
    },
  ).key;
}

K? _$enumDecodeNullable<K, V>(
  Map<K, V> enumValues,
  dynamic source, {
  K? unknownValue,
}) {
  if (source == null) {
    return null;
  }
  return _$enumDecode<K, V>(enumValues, source, unknownValue: unknownValue);
}

const _$LabelTipViewTypeEnumMap = {
  LabelTipViewType.graphics: 'graphics',
  LabelTipViewType.video: 'video',
  LabelTipViewType.grahpcisText: 'graphics_text',
};
