/* * Copyright 2020 Bundesanstalt für Materialforschung und -prüfung (BAM) *
* Licensed under the EUPL, Version 1.2 or – as soon they will be approved by the European Commission - subsequent versions of the EUPL (the "Licence");
* You may not use this work except in compliance with theLicence.
* You may obtain a copy of the Licence at:
* * https://joinup.ec.europa.eu/software/page/eupl *
* Unless required by applicable law or agreed to in writing, software distributed under the Licence is distributed on an "AS IS" basis,
* WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
* See the Licence for the specific language governing permissions and limitations under the Licence.*/

import 'package:energielabel_app/model/know_how/label_guide/checklist_entry.dart';
import 'package:json_annotation/json_annotation.dart';

part 'label_category_checklist.g.dart';

@JsonSerializable()
class LabelCategoryChecklist {
  LabelCategoryChecklist({this.checklistEntries, this.id, this.title});

  factory LabelCategoryChecklist.fromJson(Map<String, dynamic> json) => _$LabelCategoryChecklistFromJson(json);

  @JsonKey(name: 'field_id')
  final int id;

  @JsonKey(name: 'field_title')
  final String title;

  @JsonKey(name: 'field_checklist_entries')
  final List<ChecklistEntry> checklistEntries;

  Map<String, dynamic> toJson() => _$LabelCategoryChecklistToJson(this);

  @override
  String toString() {
    return 'LabelCategoryChecklist{checklistEntries: $checklistEntries, id: $id, title: $title}';
  }
}
