/* * Copyright 2020 Bundesanstalt für Materialforschung und -prüfung (BAM) *
* Licensed under the EUPL, Version 1.2 or – as soon they will be approved by the European Commission - subsequent versions of the EUPL (the "Licence");
* You may not use this work except in compliance with theLicence.
* You may obtain a copy of the Licence at:
* * https://joinup.ec.europa.eu/software/page/eupl *
* Unless required by applicable law or agreed to in writing, software distributed under the Licence is distributed on an "AS IS" basis,
* WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
* See the Licence for the specific language governing permissions and limitations under the Licence.*/

import 'package:json_annotation/json_annotation.dart';

part 'label_tip_content_image.g.dart';

@JsonSerializable()
class LabelTipContentImage {
  LabelTipContentImage({
    this.graphicPath,
    this.orderIndex,
    this.description,
  });

  factory LabelTipContentImage.fromJson(Map<String, dynamic> json) => _$LabelTipContentImageFromJson(json);

  @JsonKey(name: 'field_graphics')
  final String? graphicPath;

  @JsonKey(name: 'field_description')
  final String? description;

  @JsonKey(name: 'field_order')
  final int? orderIndex;

  Map<String, dynamic> toJson() => _$LabelTipContentImageToJson(this);

  @override
  String toString() {
    return 'LabelTipContentImage{graphicPath: $graphicPath, orderIndex: $orderIndex, description: $description}';
  }
}
