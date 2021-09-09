/* * Copyright 2020 Bundesanstalt für Materialforschung und -prüfung (BAM) *
* Licensed under the EUPL, Version 1.2 or – as soon they will be approved by the European Commission - subsequent versions of the EUPL (the "Licence");
* You may not use this work except in compliance with theLicence.
* You may obtain a copy of the Licence at:
* * https://joinup.ec.europa.eu/software/page/eupl *
* Unless required by applicable law or agreed to in writing, software distributed under the Licence is distributed on an "AS IS" basis,
* WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
* See the Licence for the specific language governing permissions and limitations under the Licence.*/

import 'package:energielabel_app/model/know_how/why_is_there/why_is_there_entry.dart';
import 'package:json_annotation/json_annotation.dart';

part 'why_is_there.g.dart';

// on change class call "flutter packages pub run build_runner build" in project root to generate *.g.dart file
// alternative use "flutter packages pub run build_runner watch" for continuous building

@JsonSerializable()
class WhyIsThere {
  WhyIsThere({this.entries});

  factory WhyIsThere.fromJson(Map<String, dynamic> json) => _$WhyIsThereFromJson(json);

  @JsonKey(name: 'why_is_there_entries')
  final List<WhyIsThereEntry>? entries;

  Map<String, dynamic> toJson() => _$WhyIsThereToJson(this);
}
