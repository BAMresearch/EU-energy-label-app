/* * Copyright 2020 Bundesanstalt für Materialforschung und -prüfung (BAM) *
* Licensed under the EUPL, Version 1.2 or – as soon they will be approved by the European Commission - subsequent versions of the EUPL (the "Licence");
* You may not use this work except in compliance with theLicence.
* You may obtain a copy of the Licence at:
* * https://joinup.ec.europa.eu/software/page/eupl *
* Unless required by applicable law or agreed to in writing, software distributed under the Licence is distributed on an "AS IS" basis,
* WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
* See the Licence for the specific language governing permissions and limitations under the Licence.*/

import 'package:energielabel_app/model/know_how/label_guide/label_tip_content_image.dart';
import 'package:energielabel_app/model/know_how/label_guide/label_tip_view_type.dart';
import 'package:json_annotation/json_annotation.dart';

part 'label_tip.g.dart';

@JsonSerializable()
class LabelTip {
  LabelTip({
    this.id,
    this.informationTitle,
    this.informationText,
    this.title,
    this.orderIndex,
    this.description,
    this.viewType,
    this.labelTipContentImages,
    this.graphicData,
    this.videoPath,
  });

  factory LabelTip.fromJson(Map<String, dynamic> json) => _$LabelTipFromJson(json);

  @JsonKey(name: 'field_id')
  final int? id;

  @JsonKey(name: 'field_information_title')
  final String? informationTitle;

  @JsonKey(name: 'field_information_text')
  final String? informationText;

  @JsonKey(name: 'field_title')
  final String? title;

  @JsonKey(name: 'field_description')
  final String? description;

  @JsonKey(name: 'field_order')
  final int? orderIndex;

  @JsonKey(name: 'field_view_type')
  final LabelTipViewType? viewType;

  @JsonKey(name: 'field_graphics')
  final String? graphicData;

  @JsonKey(name: 'field_video')
  final String? videoPath;

  @JsonKey(name: 'label_tip_content_images')
  final List<LabelTipContentImage>? labelTipContentImages;

  Map<String, dynamic> toJson() => _$LabelTipToJson(this);

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is LabelTip &&
          runtimeType == other.runtimeType &&
          id == other.id &&
          informationTitle == other.informationTitle &&
          informationText == other.informationText &&
          title == other.title &&
          description == other.description &&
          orderIndex == other.orderIndex &&
          viewType == other.viewType &&
          graphicData == other.graphicData &&
          videoPath == other.videoPath &&
          labelTipContentImages == other.labelTipContentImages;

  @override
  int get hashCode =>
      id.hashCode ^
      informationTitle.hashCode ^
      informationText.hashCode ^
      title.hashCode ^
      description.hashCode ^
      orderIndex.hashCode ^
      viewType.hashCode ^
      graphicData.hashCode ^
      videoPath.hashCode ^
      labelTipContentImages.hashCode;

  @override
  String toString() {
    return 'LabelTip{id: $id, informationTitle: $informationTitle, informationText: $informationText, title: $title, description: $description, orderIndex: $orderIndex, viewType: $viewType, graphicData: $graphicData, videoPath: $videoPath, labelTipContentImages: $labelTipContentImages}';
  }
}
