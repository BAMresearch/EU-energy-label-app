/* * Copyright 2020 Bundesanstalt für Materialforschung und -prüfung (BAM) *
* Licensed under the EUPL, Version 1.2 or – as soon they will be approved by the European Commission - subsequent versions of the EUPL (the "Licence");
* You may not use this work except in compliance with theLicence.
* You may obtain a copy of the Licence at:
* * https://joinup.ec.europa.eu/software/page/eupl *
* Unless required by applicable law or agreed to in writing, software distributed under the Licence is distributed on an "AS IS" basis,
* WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
* See the Licence for the specific language governing permissions and limitations under the Licence.*/

import 'dart:convert';

import 'package:energielabel_app/model/localized_quiz.dart';
import 'package:energielabel_app/model/quiz/quiz.dart';
import 'package:optional/optional.dart';
import 'package:shared_preferences/shared_preferences.dart';

class QuizDao {
  QuizDao(SharedPreferences sharedPreferences)
      : assert(sharedPreferences != null),
        _sharedPreferences = sharedPreferences;

  static const String _quizKey = 'quiz';
  static const String _quizLanguageKey = 'quiz_language';

  final SharedPreferences _sharedPreferences;

  Optional<LocalizedQuiz> loadQuiz() {
    final quizJsonString = _sharedPreferences.getString(_quizKey);
    final language = _sharedPreferences.getString(_quizLanguageKey);

    if (quizJsonString != null && language != null) {
      final quiz = Quiz.fromJson(jsonDecode(quizJsonString));
      return Optional.of(LocalizedQuiz(quiz, language));
    }
    return Optional.empty();
  }

  Future<void> saveQuiz(Quiz quiz, String language) async {
    await _sharedPreferences.setString(_quizKey, jsonEncode(quiz.toJson()));
    await _sharedPreferences.setString(_quizLanguageKey, language);
  }
}
