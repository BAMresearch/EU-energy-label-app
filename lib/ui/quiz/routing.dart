/* * Copyright 2020 Bundesanstalt für Materialforschung und -prüfung (BAM) *
* Licensed under the EUPL, Version 1.2 or – as soon they will be approved by the European Commission - subsequent versions of the EUPL (the "Licence");
* You may not use this work except in compliance with theLicence.
* You may obtain a copy of the Licence at:
* * https://joinup.ec.europa.eu/software/page/eupl *
* Unless required by applicable law or agreed to in writing, software distributed under the Licence is distributed on an "AS IS" basis,
* WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
* See the Licence for the specific language governing permissions and limitations under the Licence.*/

import 'package:energielabel_app/ui/quiz/pages/quiz_answer_page.dart';
import 'package:energielabel_app/ui/quiz/pages/quiz_entry_page.dart';
import 'package:energielabel_app/ui/quiz/pages/quiz_question_page.dart';
import 'package:energielabel_app/ui/quiz/pages/quiz_result_page.dart';
import 'package:flutter/material.dart';

class QuizRoutes {
  QuizRoutes._();

  static const String quizEntry = '/';
  static const String question = '/question';
  static const String answer = '/answer';
  static const String results = '/results';
}

class QuizRouter {
  QuizRouter._();

  static Route<dynamic> onGenerateRoute(RouteSettings settings) {
    switch (settings.name) {
      case QuizRoutes.quizEntry:
        return MaterialPageRoute(builder: (context) => QuizEntryPage());
      case QuizRoutes.question:
        return MaterialPageRoute(builder: (context) => QuizQuestionPage(quizState: settings.arguments));
      case QuizRoutes.answer:
        return MaterialPageRoute(builder: (context) => QuizAnswerPage(quizState: settings.arguments));
      case QuizRoutes.results:
        return MaterialPageRoute(builder: (context) => QuizResultPage(quizState: settings.arguments));
      default:
        throw ArgumentError.value(settings.name, null, 'Unexpected quiz route name.');
    }
  }
}
