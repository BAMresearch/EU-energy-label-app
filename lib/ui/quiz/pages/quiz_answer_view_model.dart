/* * Copyright 2020 Bundesanstalt für Materialforschung und -prüfung (BAM) *
* Licensed under the EUPL, Version 1.2 or – as soon they will be approved by the European Commission - subsequent versions of the EUPL (the "Licence");
* You may not use this work except in compliance with theLicence.
* You may obtain a copy of the Licence at:
* * https://joinup.ec.europa.eu/software/page/eupl *
* Unless required by applicable law or agreed to in writing, software distributed under the Licence is distributed on an "AS IS" basis,
* WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
* See the Licence for the specific language governing permissions and limitations under the Licence.*/

import 'dart:async';

import 'package:energielabel_app/ui/misc/pages/base_view_model.dart';
import 'package:energielabel_app/ui/quiz/quiz_state.dart';
import 'package:energielabel_app/ui/quiz/routing.dart';
import 'package:flutter/cupertino.dart';

class QuizAnswerViewModel extends BaseViewModel {
  QuizAnswerViewModel({required this.quizState});

  final QuizState quizState;

  int get currentIndex => quizState.level.questions!.indexOf(quizState.currentQuestion) + 1;

  int get maxIndex => quizState.level.questions!.length;

  double get progress => currentIndex / maxIndex;

  bool? get isCurrentAnswerCorrect => quizState.isCurrentAnswerCorrect;

  String? get answerText => quizState.currentQuestion.explanation;

  @override
  FutureOr<void> onViewStarted() {}

  void onNextButtonTapped(BuildContext context) {
    quizState.saveAnswer();
    if (!quizState.isQuizOver) {
      Navigator.of(context).pushNamed(QuizRoutes.question, arguments: quizState);
    } else {
      Navigator.of(context).pushNamed(QuizRoutes.results, arguments: quizState);
    }
  }
}
