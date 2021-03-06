/* * Copyright 2020 Bundesanstalt für Materialforschung und -prüfung (BAM) *
* Licensed under the EUPL, Version 1.2 or – as soon they will be approved by the European Commission - subsequent versions of the EUPL (the "Licence");
* You may not use this work except in compliance with theLicence.
* You may obtain a copy of the Licence at:
* * https://joinup.ec.europa.eu/software/page/eupl *
* Unless required by applicable law or agreed to in writing, software distributed under the Licence is distributed on an "AS IS" basis,
* WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
* See the Licence for the specific language governing permissions and limitations under the Licence.*/

import 'package:energielabel_app/model/quiz/answer.dart';
import 'package:energielabel_app/model/quiz/level.dart';
import 'package:energielabel_app/model/quiz/question.dart';

class QuizState {
  QuizState({required this.level, String? title}) : _title = title;

  final String? _title;

  final List<Answer?> selectedAnswers = [];

  final Level level;

  bool? get isCurrentAnswerCorrect => _currentAnswer!.isCorrect;
  Answer? _currentAnswer;

  bool get isQuizOver => selectedAnswers.length == level.questions!.length;

  String? get title => _title;

  int get correctAnswers => selectedAnswers.where((Answer? answerOption) => answerOption!.isCorrect!).length;

  Question get currentQuestion => level.questions![selectedAnswers.length];

  void checkInAnswer(Answer? answerOption) {
    _currentAnswer = answerOption;
  }

  void saveAnswer() {
    if (!selectedAnswers.contains(_currentAnswer)) {
      selectedAnswers.add(_currentAnswer);
    }
  }
}
