/* * Copyright 2020 Bundesanstalt für Materialforschung und -prüfung (BAM) *
* Licensed under the EUPL, Version 1.2 or – as soon they will be approved by the European Commission - subsequent versions of the EUPL (the "Licence");
* You may not use this work except in compliance with theLicence.
* You may obtain a copy of the Licence at:
* * https://joinup.ec.europa.eu/software/page/eupl *
* Unless required by applicable law or agreed to in writing, software distributed under the Licence is distributed on an "AS IS" basis,
* WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
* See the Licence for the specific language governing permissions and limitations under the Licence.*/

import 'package:energielabel_app/model/know_how/label_guide/label_category_checklist_data.dart';
import 'package:json_annotation/json_annotation.dart';

import 'label_category_guide_data.dart';
import 'label_category_tip_data.dart';

part 'label_category.g.dart';

@JsonSerializable()
class LabelCategory {
  LabelCategory({
    this.id,
    this.productType,
    this.description,
    this.backgroundColorHex,
    this.textColorHex,
    this.graphicPath,
    this.orderIndex,
    this.checklistData,
    this.tipData,
    this.guideData,
    this.visible,
    this.favoriteOnly,
  });

  factory LabelCategory.fromJson(Map<String, dynamic> json) => _$LabelCategoryFromJson(json);

  @JsonKey(name: 'field_id')
  final int id;

  @JsonKey(name: 'field_producttype')
  final String productType;

  @JsonKey(name: 'field_description')
  final String description;

  @JsonKey(name: 'field_background_color_hex')
  final String backgroundColorHex;

  @JsonKey(name: 'field_text_color_hex')
  final String textColorHex;

  @JsonKey(name: 'field_graphics')
  final String graphicPath;

  @JsonKey(name: 'field_order')
  final int orderIndex;

  @JsonKey(name: 'label_category_checklist_data')
  final LabelCategoryChecklistData checklistData;

  @JsonKey(name: 'label_category_tips')
  final LabelCategoryTipData tipData;

  @JsonKey(name: 'label_category_guide')
  final LabelCategoryGuideData guideData;

  @JsonKey(name: 'visible')
  final bool visible;

  @JsonKey(name: 'favorite_only')
  final bool favoriteOnly;

  Map<String, dynamic> toJson() => _$LabelCategoryToJson(this);

  @override
  String toString() {
    return 'LabelCategory{id: $id, productType: $productType, description: $description, backgroundColorHex: $backgroundColorHex, textColorHex: $textColorHex, graphicPath: $graphicPath, orderIndex: $orderIndex, checklistData: $checklistData, tipData: $tipData, visible: $visible, favoriteOnly: $favoriteOnly}';
  }
}
