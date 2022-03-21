// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'label_tip_content_image.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

LabelTipContentImage _$LabelTipContentImageFromJson(Map<String, dynamic> json) => LabelTipContentImage(
      graphicPath: json['field_graphics'] as String?,
      orderIndex: json['field_order'] as int?,
      description: json['field_description'] as String?,
    );

Map<String, dynamic> _$LabelTipContentImageToJson(LabelTipContentImage instance) => <String, dynamic>{
      'field_graphics': instance.graphicPath,
      'field_description': instance.description,
      'field_order': instance.orderIndex,
    };
