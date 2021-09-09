/* * Copyright 2020 Bundesanstalt für Materialforschung und -prüfung (BAM) *
* Licensed under the EUPL, Version 1.2 or – as soon they will be approved by the European Commission - subsequent versions of the EUPL (the "Licence");
* You may not use this work except in compliance with theLicence.
* You may obtain a copy of the Licence at:
* * https://joinup.ec.europa.eu/software/page/eupl *
* Unless required by applicable law or agreed to in writing, software distributed under the Licence is distributed on an "AS IS" basis,
* WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
* See the Licence for the specific language governing permissions and limitations under the Licence.*/

import 'package:energielabel_app/model/know_how/label_guide/label_category_checklist.dart';
import 'package:json_annotation/json_annotation.dart';

part 'label_category_checklist_data.g.dart';

@JsonSerializable()
class LabelCategoryChecklistData {
  LabelCategoryChecklistData(
      {this.id,
      this.title,
      this.graphicPath,
      this.orderIndex,
      this.checklists,
      this.introText,
      this.informationText,
      this.informationTitle});

  factory LabelCategoryChecklistData.fromJson(Map<String, dynamic> json) => _$LabelCategoryChecklistDataFromJson(json);

  @JsonKey(name: 'field_id')
  final int? id;

  @JsonKey(name: 'field_title')
  final String? title;

  @JsonKey(name: 'field_graphics')
  final String? graphicPath;

  @JsonKey(name: 'field_intro')
  final String? introText;

  @JsonKey(name: 'field_order')
  final int? orderIndex;

  @JsonKey(name: 'label_category_checklists')
  final List<LabelCategoryChecklist>? checklists;

  @JsonKey(name: 'field_information_title')
  final String? informationTitle;

  @JsonKey(name: 'field_information_text')
  final String? informationText;

  Map<String, dynamic> toJson() => _$LabelCategoryChecklistDataToJson(this);

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is LabelCategoryChecklistData && runtimeType == other.runtimeType && id == other.id;

  @override
  int get hashCode => id.hashCode;

  @override
  String toString() {
    return 'LabelCategoryChecklistData{title: $title, introText: $introText, graphicPath: $graphicPath, orderIndex: $orderIndex, id: $id, checklists: $checklists, informationTitle: $informationTitle, informationText: $informationText}';
  }
}
