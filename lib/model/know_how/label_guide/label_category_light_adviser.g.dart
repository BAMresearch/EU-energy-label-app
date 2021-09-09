// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'label_category_light_adviser.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

LabelCategoryLightAdviser _$LabelCategoryLightAdviserFromJson(
    Map<String, dynamic> json) {
  return LabelCategoryLightAdviser(
    json['title'] as String?,
    InfoSection.fromJson(json['info_section'] as Map<String, dynamic>),
    (json['bulb_images'] as List<dynamic>)
        .map((e) => BulbImage.fromJson(e as Map<String, dynamic>))
        .toList(),
    (json['brightness_levels'] as Map<String, dynamic>).map(
      (k, e) => MapEntry(_$enumDecode(_$BrightnessTypeEnumMap, k),
          Brightness.fromJson(e as Map<String, dynamic>)),
    ),
    (json['rooms'] as Map<String, dynamic>).map(
      (k, e) => MapEntry(_$enumDecode(_$RoomTypeEnumMap, k),
          Room.fromJson(e as Map<String, dynamic>)),
    ),
    json['intro_text'] as String,
    json['category_brightness_label'] as String,
    json['category_color_temperature_label'] as String,
    json['button_label'] as String,
    json['rooms_title'] as String,
    json['selection_hint'] as String,
    json['brightness_info_sheet_top_label'] as String,
    json['brightness_unit'] as String,
    json['color_temperature_unit'] as String,
    json['approximately_label'] as String,
  );
}

Map<String, dynamic> _$LabelCategoryLightAdviserToJson(
        LabelCategoryLightAdviser instance) =>
    <String, dynamic>{
      'title': instance.title,
      'intro_text': instance.introText,
      'rooms_title': instance.roomsTitle,
      'brightness_info_sheet_top_label': instance.brightnessInfoSheetTopLabel,
      'selection_hint': instance.selectionHint,
      'category_brightness_label': instance.categoryBrightnessLabel,
      'category_color_temperature_label': instance.categoryColorTemeratureLabel,
      'info_section': instance.infoSection,
      'bulb_images': instance.bulbImages,
      'brightness_levels': instance.brightnessLevels
          .map((k, e) => MapEntry(_$BrightnessTypeEnumMap[k], e)),
      'rooms': instance.rooms.map((k, e) => MapEntry(_$RoomTypeEnumMap[k], e)),
      'button_label': instance.buttonLabel,
      'brightness_unit': instance.brightnessUnit,
      'approximately_label': instance.approximatelyLabel,
      'color_temperature_unit': instance.colorTemperatureUnit,
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

const _$BrightnessTypeEnumMap = {
  BrightnessType.dark: 'dark',
  BrightnessType.lowLight: 'low_light',
  BrightnessType.bright: 'bright',
  BrightnessType.veryBright: 'very_bright',
  BrightnessType.ultraBright: 'ultra_bright',
};

const _$RoomTypeEnumMap = {
  RoomType.bedRoom: 'bed_room',
  RoomType.livingRoom: 'living_room',
  RoomType.childsRoom: 'childs_room',
  RoomType.kitchen: 'kitchen',
  RoomType.bath: 'bath',
  RoomType.stairs: 'stairs',
  RoomType.study: 'study',
  RoomType.atelier: 'atelier',
  RoomType.mirror: 'mirror',
};

InfoSection _$InfoSectionFromJson(Map<String, dynamic> json) {
  return InfoSection(
    json['top_text'] as String,
    json['middle_text'] as String,
    json['middle_title'] as String,
    json['bottom_text'] as String,
    json['bottom_title'] as String,
  );
}

Map<String, dynamic> _$InfoSectionToJson(InfoSection instance) =>
    <String, dynamic>{
      'top_text': instance.topText,
      'middle_title': instance.middleTitle,
      'middle_text': instance.middleText,
      'bottom_title': instance.bottomTitle,
      'bottom_text': instance.bottomText,
    };

BulbImage _$BulbImageFromJson(Map<String, dynamic> json) {
  return BulbImage(
    json['image'] as String,
    (json['brightness_room'] as List<dynamic>)
        .map((e) => BrightnessRoom.fromJson(e as Map<String, dynamic>))
        .toList(),
  );
}

Map<String, dynamic> _$BulbImageToJson(BulbImage instance) => <String, dynamic>{
      'image': instance.image,
      'brightness_room': instance.brightnessRoom,
    };

BrightnessRoom _$BrightnessRoomFromJson(Map<String, dynamic> json) {
  return BrightnessRoom(
    _$enumDecode(_$BrightnessTypeEnumMap, json['brightness']),
    _$enumDecode(_$RoomTypeEnumMap, json['room']),
  );
}

Map<String, dynamic> _$BrightnessRoomToJson(BrightnessRoom instance) =>
    <String, dynamic>{
      'brightness': _$BrightnessTypeEnumMap[instance.brightness],
      'room': _$RoomTypeEnumMap[instance.room],
    };

Brightness _$BrightnessFromJson(Map<String, dynamic> json) {
  return Brightness(
    json['brightness'] as String,
    json['icon_file_name'] as String,
    json['power'] as String,
    json['description'] as String,
  );
}

Map<String, dynamic> _$BrightnessToJson(Brightness instance) =>
    <String, dynamic>{
      'brightness': instance.brightness,
      'description': instance.description,
      'power': instance.power,
      'icon_file_name': instance.iconFileName,
    };

Room _$RoomFromJson(Map<String, dynamic> json) {
  return Room(
    json['label'] as String,
    json['icon_file_name'] as String,
    json['temperature'] as String,
    json['description'] as String,
  );
}

Map<String, dynamic> _$RoomToJson(Room instance) => <String, dynamic>{
      'label': instance.label,
      'temperature': instance.temperature,
      'description': instance.description,
      'icon_file_name': instance.iconFileName,
    };
