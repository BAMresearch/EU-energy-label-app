/* * Copyright 2020 Bundesanstalt für Materialforschung und -prüfung (BAM) *
* Licensed under the EUPL, Version 1.2 or – as soon they will be approved by the European Commission - subsequent versions of the EUPL (the "Licence");
* You may not use this work except in compliance with theLicence.
* You may obtain a copy of the Licence at:
* * https://joinup.ec.europa.eu/software/page/eupl *
* Unless required by applicable law or agreed to in writing, software distributed under the Licence is distributed on an "AS IS" basis,
* WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
* See the Licence for the specific language governing permissions and limitations under the Licence.*/

import 'package:energielabel_app/model/know_how/label_guide/label_category.dart';
import 'package:json_annotation/json_annotation.dart';

part 'label_guide.g.dart';

@JsonSerializable()
class LabelGuide {
  LabelGuide({this.title, this.labelCategories});

  factory LabelGuide.fromJson(Map<String, dynamic> json) => _$LabelGuideFromJson(json);

  @JsonKey(name: 'field_title')
  final String? title;

  @JsonKey(name: 'label_categories')
  final List<LabelCategory>? labelCategories;

  Map<String, dynamic> toJson() => _$LabelGuideToJson(this);

  @override
  String toString() {
    return 'LabelGuide{title: $title, labelCategories: $labelCategories}';
  }
}
