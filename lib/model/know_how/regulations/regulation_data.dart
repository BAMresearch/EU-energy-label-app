/* * Copyright 2020 Bundesanstalt für Materialforschung und -prüfung (BAM) *
* Licensed under the EUPL, Version 1.2 or – as soon they will be approved by the European Commission - subsequent versions of the EUPL (the "Licence");
* You may not use this work except in compliance with theLicence.
* You may obtain a copy of the Licence at:
* * https://joinup.ec.europa.eu/software/page/eupl *
* Unless required by applicable law or agreed to in writing, software distributed under the Licence is distributed on an "AS IS" basis,
* WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
* See the Licence for the specific language governing permissions and limitations under the Licence.*/

import 'package:energielabel_app/model/know_how/regulations/regulation.dart';
import 'package:json_annotation/json_annotation.dart';

part 'regulation_data.g.dart';

// on change class call "flutter packages pub run build_runner build" in project root to generate *.g.dart file
// alternatively use "flutter packages pub run build_runner watch" for continuous building

@JsonSerializable()
class RegulationData {
  RegulationData({this.title, this.description, this.regulations});

  factory RegulationData.fromJson(Map<String, dynamic> json) => _$RegulationDataFromJson(json);

  @JsonKey(name: 'title')
  final String? title;

  @JsonKey(name: 'description')
  final String? description;

  @JsonKey(name: 'regulations')
  final List<Regulation>? regulations;

  Map<String, dynamic> toJson() => _$RegulationDataToJson(this);

  @override
  String toString() {
    return 'RegulationData{title: $title, description: $description, regulations: $regulations}';
  }
}
