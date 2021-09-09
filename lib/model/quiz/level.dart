/* * Copyright 2020 Bundesanstalt für Materialforschung und -prüfung (BAM) *
* Licensed under the EUPL, Version 1.2 or – as soon they will be approved by the European Commission - subsequent versions of the EUPL (the "Licence");
* You may not use this work except in compliance with theLicence.
* You may obtain a copy of the Licence at:
* * https://joinup.ec.europa.eu/software/page/eupl *
* Unless required by applicable law or agreed to in writing, software distributed under the Licence is distributed on an "AS IS" basis,
* WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
* See the Licence for the specific language governing permissions and limitations under the Licence.*/

import 'package:energielabel_app/model/quiz/question.dart';
import 'package:energielabel_app/model/quiz/score.dart';
import 'package:json_annotation/json_annotation.dart';

part 'level.g.dart';

@JsonSerializable()
class Level {
  Level({this.name, this.questions, this.score, this.icon});

  factory Level.fromJson(Map<String, dynamic> json) => _$LevelFromJson(json);

  @JsonKey(name: 'title')
  final String? name;

  @JsonKey(name: 'icon-svg')
  final String? icon;

  @JsonKey(name: 'questions')
  final List<Question>? questions;

  @JsonKey(name: 'score')
  final Score? score;

  Map<String, dynamic> toJson() => _$LevelToJson(this);

  @override
  String toString() {
    return 'Level{name: $name, questions: $questions, icon: $icon}';
  }
}
