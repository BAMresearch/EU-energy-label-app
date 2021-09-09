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
import 'package:flutter/cupertino.dart';

class QuizResultViewModel extends BaseViewModel {
  QuizResultViewModel({required this.quizState, required this.context});

  final QuizState quizState;
  final BuildContext context;

  int get maxIndex => quizState.level.questions!.length;

  int get correctAnswers => quizState.correctAnswers;

  String? get positiveResult => quizState.level.score!.positive;

  String? get negativeResult => quizState.level.score!.negative;

  bool get isResultPositive => correctAnswers >= quizState.level.score!.minPositiveScore!;

  @override
  FutureOr<void> onViewStarted() {}

  void onReplyButtonTapped() {
    Navigator.of(context).popUntil((route) => route.isFirst);
  }
}
