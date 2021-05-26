/* * Copyright 2020 Bundesanstalt für Materialforschung und -prüfung (BAM) *
* Licensed under the EUPL, Version 1.2 or – as soon they will be approved by the European Commission - subsequent versions of the EUPL (the "Licence");
* You may not use this work except in compliance with theLicence.
* You may obtain a copy of the Licence at:
* * https://joinup.ec.europa.eu/software/page/eupl *
* Unless required by applicable law or agreed to in writing, software distributed under the Licence is distributed on an "AS IS" basis,
* WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
* See the Licence for the specific language governing permissions and limitations under the Licence.*/

import 'package:energielabel_app/model/quiz/answer.dart';
import 'package:json_annotation/json_annotation.dart';

part 'question.g.dart';

@JsonSerializable()
class Question {
  Question({this.viewType, this.title, this.explanation, this.answers});

  factory Question.fromJson(Map<String, dynamic> json) => _$QuestionFromJson(json);

  @JsonKey(name: 'view-type')
  final String viewType;

  @JsonKey(name: 'title')
  final String title;

  @JsonKey(name: 'explanation')
  final String explanation;

  @JsonKey(name: 'answers')
  final List<Answer> answers;

  Map<String, dynamic> toJson() => _$QuestionToJson(this);

  @override
  String toString() {
    return 'Question{viewType: $viewType, questionText: $title, explanation: $explanation, answers: $answers}';
  }
}
