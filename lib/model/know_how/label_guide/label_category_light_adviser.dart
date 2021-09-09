/* * Copyright 2020 Bundesanstalt für Materialforschung und -prüfung (BAM) *
* Licensed under the EUPL, Version 1.2 or – as soon they will be approved by the European Commission - subsequent versions of the EUPL (the "Licence");
* You may not use this work except in compliance with theLicence.
* You may obtain a copy of the Licence at:
* * https://joinup.ec.europa.eu/software/page/eupl *
* Unless required by applicable law or agreed to in writing, software distributed under the Licence is distributed on an "AS IS" basis,
* WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
* See the Licence for the specific language governing permissions and limitations under the Licence.*/

import 'package:json_annotation/json_annotation.dart';

part 'label_category_light_adviser.g.dart';

@JsonSerializable()
class LabelCategoryLightAdviser {
  LabelCategoryLightAdviser(
    this.title,
    this.infoSection,
    this.bulbImages,
    this.brightnessLevels,
    this.rooms,
    this.introText,
    this.categoryBrightnessLabel,
    this.categoryColorTemeratureLabel,
    this.buttonLabel,
    this.roomsTitle,
    this.selectionHint,
    this.brightnessInfoSheetTopLabel,
    this.brightnessUnit,
    this.colorTemperatureUnit,
    this.approximatelyLabel,
  );

  factory LabelCategoryLightAdviser.fromJson(Map<String, dynamic> json) => _$LabelCategoryLightAdviserFromJson(json);

  final String? title;

  @JsonKey(name: 'intro_text')
  final String introText;

  @JsonKey(name: 'rooms_title')
  final String roomsTitle;

  @JsonKey(name: 'brightness_info_sheet_top_label')
  final String brightnessInfoSheetTopLabel;

  @JsonKey(name: 'selection_hint')
  final String selectionHint;

  @JsonKey(name: 'category_brightness_label')
  final String categoryBrightnessLabel;

  @JsonKey(name: 'category_color_temperature_label')
  final String categoryColorTemeratureLabel;

  @JsonKey(name: 'info_section')
  final InfoSection infoSection;

  @JsonKey(name: 'bulb_images')
  List<BulbImage> bulbImages;

  @JsonKey(name: 'brightness_levels')
  Map<BrightnessType, Brightness> brightnessLevels;

  @JsonKey(name: 'rooms')
  Map<RoomType, Room> rooms;

  @JsonKey(name: 'button_label')
  String buttonLabel;

  @JsonKey(name: 'brightness_unit')
  String brightnessUnit;

  @JsonKey(name: 'approximately_label')
  String approximatelyLabel;

  @JsonKey(name: 'color_temperature_unit')
  String colorTemperatureUnit;

  Map<String, dynamic> toJson() => _$LabelCategoryLightAdviserToJson(this);
}

@JsonSerializable()
class InfoSection {
  InfoSection(
    this.topText,
    this.middleText,
    this.middleTitle,
    this.bottomText,
    this.bottomTitle,
  );

  factory InfoSection.fromJson(Map<String, dynamic> json) => _$InfoSectionFromJson(json);

  @JsonKey(name: 'top_text')
  String topText;

  @JsonKey(name: 'middle_title')
  String middleTitle;

  @JsonKey(name: 'middle_text')
  String middleText;

  @JsonKey(name: 'bottom_title')
  String bottomTitle;

  @JsonKey(name: 'bottom_text')
  String bottomText;

  Map<String, dynamic> toJson() => _$InfoSectionToJson(this);
}

@JsonSerializable()
class BulbImage {
  BulbImage(this.image, this.brightnessRoom);

  factory BulbImage.fromJson(Map<String, dynamic> json) => _$BulbImageFromJson(json);

  @JsonKey(name: 'image')
  String image;

  @JsonKey(name: 'brightness_room')
  List<BrightnessRoom> brightnessRoom;

  Map<String, dynamic> toJson() => _$BulbImageToJson(this);
}

@JsonSerializable()
class BrightnessRoom {
  BrightnessRoom(this.brightness, this.room);

  factory BrightnessRoom.fromJson(Map<String, dynamic> json) => _$BrightnessRoomFromJson(json);

  @JsonKey(name: 'brightness')
  BrightnessType brightness;

  @JsonKey(name: 'room')
  RoomType room;

  Map<String, dynamic> toJson() => _$BrightnessRoomToJson(this);
}

@JsonSerializable()
class Brightness {
  Brightness(this.brightness, this.iconFileName, this.power, this.description);

  factory Brightness.fromJson(Map<String, dynamic> json) => _$BrightnessFromJson(json);

  @JsonKey(name: 'brightness')
  String brightness;

  @JsonKey(name: 'description')
  String description;

  @JsonKey(name: 'power')
  String power;

  @JsonKey(name: 'icon_file_name')
  String iconFileName;

  Map<String, dynamic> toJson() => _$BrightnessToJson(this);
}

@JsonSerializable()
class Room {
  Room(this.label, this.iconFileName, this.temperature, this.description);

  factory Room.fromJson(Map<String, dynamic> json) => _$RoomFromJson(json);

  @JsonKey(name: 'label')
  String label;

  @JsonKey(name: 'temperature')
  String temperature;

  @JsonKey(name: 'description')
  String description;

  @JsonKey(name: 'icon_file_name')
  String iconFileName;

  Map<String, dynamic> toJson() => _$RoomToJson(this);
}

enum BrightnessType {
  @JsonValue('dark')
  dark,
  @JsonValue('low_light')
  lowLight,
  @JsonValue('bright')
  bright,
  @JsonValue('very_bright')
  veryBright,
  @JsonValue('ultra_bright')
  ultraBright
}

enum RoomType {
  @JsonValue('bed_room')
  bedRoom,
  @JsonValue('living_room')
  livingRoom,
  @JsonValue('childs_room')
  childsRoom,
  @JsonValue('kitchen')
  kitchen,
  @JsonValue('bath')
  bath,
  @JsonValue('stairs')
  stairs,
  @JsonValue('study')
  study,
  @JsonValue('atelier')
  atelier,
  @JsonValue('mirror')
  mirror
}
