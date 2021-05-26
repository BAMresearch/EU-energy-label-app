/* * Copyright 2020 Bundesanstalt für Materialforschung und -prüfung (BAM) *
* Licensed under the EUPL, Version 1.2 or – as soon they will be approved by the European Commission - subsequent versions of the EUPL (the "Licence");
* You may not use this work except in compliance with theLicence.
* You may obtain a copy of the Licence at:
* * https://joinup.ec.europa.eu/software/page/eupl *
* Unless required by applicable law or agreed to in writing, software distributed under the Licence is distributed on an "AS IS" basis,
* WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
* See the Licence for the specific language governing permissions and limitations under the Licence.*/

import 'package:json_annotation/json_annotation.dart';

part 'label_category_guide_data.g.dart';

@JsonSerializable()
class LabelCategoryGuideData {
  LabelCategoryGuideData({
    this.title,
    this.introText,
    this.outroText,
    this.informationTitle,
    this.informationText,
    this.fridgeLeftSideInfoZones,
    this.fridgeRightSideInfoZones,
  });

  factory LabelCategoryGuideData.fromJson(Map<String, dynamic> json) => _$LabelCategoryGuideDataFromJson(json);

  @JsonKey(name: 'field_title')
  final String title;

  @JsonKey(name: 'field_intro')
  final String introText;

  @JsonKey(name: 'field_outro')
  final String outroText;

  @JsonKey(name: 'field_information_title')
  final String informationTitle;

  @JsonKey(name: 'field_information_text')
  final String informationText;

  @JsonKey(name: 'fridge_left_info_zones')
  final List<FridgeInfoZoneData> fridgeLeftSideInfoZones;

  @JsonKey(name: 'fridge_right_info_zones')
  final List<FridgeInfoZoneData> fridgeRightSideInfoZones;

  Map<String, dynamic> toJson() => _$LabelCategoryGuideDataToJson(this);

  @override
  String toString() {
    return 'LabelCategoryGuideData($title, $introText, $outroText, $informationTitle, $informationText)';
  }
}

@JsonSerializable()
class FridgeInfoZoneData {
  const FridgeInfoZoneData({this.description, this.tooltipHtml});

  factory FridgeInfoZoneData.fromJson(Map<String, dynamic> json) => _$FridgeInfoZoneDataFromJson(json);

  @JsonKey(name: 'field_zone')
  final String description;

  @JsonKey(name: 'field_tooltip')
  final String tooltipHtml;

  Map<String, dynamic> toJson() => _$FridgeInfoZoneDataToJson(this);
}
