// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'regulation.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Regulation _$RegulationFromJson(Map<String, dynamic> json) {
  return Regulation(
    title: json['title'] as String?,
    pdfPath: json['pdf-path'] as String?,
    orderIndex: json['order-index'] as int?,
  );
}

Map<String, dynamic> _$RegulationToJson(Regulation instance) =>
    <String, dynamic>{
      'title': instance.title,
      'pdf-path': instance.pdfPath,
      'order-index': instance.orderIndex,
    };
