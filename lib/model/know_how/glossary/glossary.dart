/* * Copyright 2020 Bundesanstalt für Materialforschung und -prüfung (BAM) *
* Licensed under the EUPL, Version 1.2 or – as soon they will be approved by the European Commission - subsequent versions of the EUPL (the "Licence");
* You may not use this work except in compliance with theLicence.
* You may obtain a copy of the Licence at:
* * https://joinup.ec.europa.eu/software/page/eupl *
* Unless required by applicable law or agreed to in writing, software distributed under the Licence is distributed on an "AS IS" basis,
* WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
* See the Licence for the specific language governing permissions and limitations under the Licence.*/

import 'package:energielabel_app/model/know_how/glossary/glossary_entry.dart';
import 'package:json_annotation/json_annotation.dart';

part 'glossary.g.dart';

@JsonSerializable()
class Glossary {
  Glossary({this.glossaryEntries});

  factory Glossary.fromJson(Map<String, dynamic> json) => _$GlossaryFromJson(json);

  @JsonKey(name: 'glossary-entries')
  final List<GlossaryEntry> glossaryEntries;

  Map<String, dynamic> toJson() => _$GlossaryToJson(this);
}
