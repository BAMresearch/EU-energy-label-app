/* * Copyright 2020 Bundesanstalt für Materialforschung und -prüfung (BAM) *
* Licensed under the EUPL, Version 1.2 or – as soon they will be approved by the European Commission - subsequent versions of the EUPL (the "Licence");
* You may not use this work except in compliance with theLicence.
* You may obtain a copy of the Licence at:
* * https://joinup.ec.europa.eu/software/page/eupl *
* Unless required by applicable law or agreed to in writing, software distributed under the Licence is distributed on an "AS IS" basis,
* WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
* See the Licence for the specific language governing permissions and limitations under the Licence.*/

import 'package:json_annotation/json_annotation.dart';

part 'why_is_there_entry.g.dart';

@JsonSerializable()
class WhyIsThereEntry {
  WhyIsThereEntry({this.title, this.orderIndex, this.text, this.textSemantic, this.imageUri, this.videoUri});

  factory WhyIsThereEntry.fromJson(Map<String, dynamic> json) => _$WhyIsThereEntryFromJson(json);

  @JsonKey(name: 'field_title')
  final String title;

  @JsonKey(name: 'field_text')
  final String text;

  @JsonKey(name: 'field_text_semantic')
  final String textSemantic;

  @JsonKey(name: 'field_image')
  final String imageUri;

  @JsonKey(name: 'field_video')
  final String videoUri;

  @JsonKey(name: 'field_order')
  final int orderIndex;

  Map<String, dynamic> toJson() => _$WhyIsThereEntryToJson(this);

  @override
  String toString() {
    return 'Quiz{title: $title, text: $text, imageUri: $imageUri, videoUri: $videoUri, orderIndex: $orderIndex}';
  }
}
