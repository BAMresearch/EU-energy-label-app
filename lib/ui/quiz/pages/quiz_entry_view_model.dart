/* * Copyright 2020 Bundesanstalt für Materialforschung und -prüfung (BAM) *
* Licensed under the EUPL, Version 1.2 or – as soon they will be approved by the European Commission - subsequent versions of the EUPL (the "Licence");
* You may not use this work except in compliance with theLicence.
* You may obtain a copy of the Licence at:
* * https://joinup.ec.europa.eu/software/page/eupl *
* Unless required by applicable law or agreed to in writing, software distributed under the Licence is distributed on an "AS IS" basis,
* WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
* See the Licence for the specific language governing permissions and limitations under the Licence.*/

import 'package:energielabel_app/data/quiz_repository.dart';
import 'package:energielabel_app/model/quiz/level.dart';
import 'package:energielabel_app/model/quiz/quiz.dart';
import 'package:energielabel_app/ui/misc/pages/base_view_model.dart';
import 'package:energielabel_app/ui/quiz/quiz_state.dart';
import 'package:energielabel_app/ui/quiz/routing.dart';
import 'package:flutter/cupertino.dart';
import 'package:pedantic/pedantic.dart';

class QuizEntryViewModel extends BaseViewModel {
  QuizEntryViewModel({
    required BuildContext context,
    required QuizRepository quizRepository,
  })   : _context = context,
        _quizRepository = quizRepository;

  final BuildContext _context;
  final QuizRepository _quizRepository;
  Quiz? _quizData;

  String get quizTitle => _quizData?.title ?? '';

  String get quizDescription => _quizData?.description ?? '';

  List<Level>? get levels => _quizData != null ? _quizData!.levels : [];

  @override
  void onViewStarted() {
    unawaited(_loadQuizData());
  }

  void onLevelSelected(Level level) {
    Navigator.of(_context).pushNamed(QuizRoutes.question, arguments: QuizState(level: level, title: _quizData!.title));
  }

  Future<void> _loadQuizData() async {
    _quizData = await _quizRepository.loadQuiz();

    notifyListeners();
  }
}
