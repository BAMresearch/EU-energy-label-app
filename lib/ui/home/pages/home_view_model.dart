/* * Copyright 2020 Bundesanstalt für Materialforschung und -prüfung (BAM) *
* Licensed under the EUPL, Version 1.2 or – as soon they will be approved by the European Commission - subsequent versions of the EUPL (the "Licence");
* You may not use this work except in compliance with theLicence.
* You may obtain a copy of the Licence at:
* * https://joinup.ec.europa.eu/software/page/eupl *
* Unless required by applicable law or agreed to in writing, software distributed under the Licence is distributed on an "AS IS" basis,
* WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
* See the Licence for the specific language governing permissions and limitations under the Licence.*/

import 'package:energielabel_app/data/news_repository.dart';
import 'package:energielabel_app/data/quiz_repository.dart';
import 'package:energielabel_app/data/settings_repository.dart';
import 'package:energielabel_app/model/home/news.dart';
import 'package:energielabel_app/ui/favorites/favorites_routes.dart';
import 'package:energielabel_app/ui/favorites/favorites_tab_specification.dart';
import 'package:energielabel_app/ui/home/home_tab_specification.dart';
import 'package:energielabel_app/ui/home/routing.dart';
import 'package:energielabel_app/ui/know_how/know_how_routes.dart';
import 'package:energielabel_app/ui/know_how/know_how_tab_specification.dart';
import 'package:energielabel_app/ui/misc/pages/base_view_model.dart';
import 'package:energielabel_app/ui/misc/tab_scaffold.dart';
import 'package:energielabel_app/ui/quiz/quiz_tab_specification.dart';
import 'package:energielabel_app/ui/quiz/routing.dart';
import 'package:energielabel_app/ui/scanner/routing.dart';
import 'package:energielabel_app/ui/scanner/scanner_tab_specification.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_fimber/flutter_fimber.dart';
import 'package:optional/optional.dart';
import 'package:pedantic/pedantic.dart';

class HomeViewModel extends BaseViewModel {
  HomeViewModel({
    @required BuildContext context,
    @required QuizRepository quizRepository,
    @required NewsRepository newsRepository,
    @required SettingsRepository settingsRepository,
    @required QuizUpdateAvailableCallback quizUpdateAvailableCallback,
  })  : assert(context != null),
        assert(quizRepository != null),
        assert(newsRepository != null),
        assert(settingsRepository != null),
        assert(quizUpdateAvailableCallback != null),
        _context = context,
        _quizRepository = quizRepository,
        _newsRepository = newsRepository,
        _settingsRepository = settingsRepository,
        _quizUpdateAvailableCallback = quizUpdateAvailableCallback;

  final BuildContext _context;
  final NewsRepository _newsRepository;
  final QuizRepository _quizRepository;
  final SettingsRepository _settingsRepository;
  final QuizUpdateAvailableCallback _quizUpdateAvailableCallback;
  Optional<News> _unreadNews = Optional.empty();

  bool get hasUnreadNews => _unreadNews.isPresent;

  Optional<News> get unreadNews => _unreadNews;

  @override
  void onViewStarted() {
    unawaited(_checkForQuizUpdates());
  }

  void onViewVisibilityChanged(bool becameVisible) {
    if (becameVisible) {
      unawaited(_loadUnreadNews());
    }
  }

  void onNewsClosedAction() {
    unawaited(_newsRepository.saveNews(_unreadNews.value.copyWith(markedRead: true)));
    _unreadNews = Optional.empty();
    notifyListeners();
  }

  Future<void> onQuizUpdateConfirmed() async {
    try {
      await _quizRepository.syncQuiz();
      unawaited(_settingsRepository.setDeferredQuizUpdateAvailable(false));
    } catch (e) {
      Fimber.e('Failed to sync the quiz.', ex: e);
    }
  }

  void onQuizUpdateDeclined() {
    unawaited(_settingsRepository.setDeferredQuizUpdateAvailable(true));
  }

  void onLabelGuideTilePressed() {
    TabScaffold.of(_context).navigateIntoTab(KnowHowTabSpecification, KnowHowRoutes.labelGuideCategoriesOverview);
  }

  void onScannerTilePressed() {
    TabScaffold.of(_context).navigateIntoTab(ScannerTabSpecification, ScannerRoutes.root);
  }

  void onFavoriteTilePressed() {
    TabScaffold.of(_context).navigateIntoTab(FavoritesTabSpecification, FavoritesRoutes.root);
  }

  void onFirstStepsTilePressed() {
    TabScaffold.of(_context).navigateIntoTab(HomeTabSpecification, HomeRoutes.firstSteps);
  }

  void onQuizTilePressed() {
    TabScaffold.of(_context).navigateIntoTab(QuizTabSpecification, QuizRoutes.quizEntry);
  }

  Future<void> _loadUnreadNews() async {
    try {
      await _newsRepository.syncNews();

      final news = _newsRepository.loadNews();
      if (news.isPresent && !news.value.markedRead) {
        _unreadNews = news;
      } else {
        _unreadNews = Optional.empty();
      }
    } catch (e) {
      Fimber.e('Failed to load unread news.', ex: e);
    } finally {
      notifyListeners();
    }
  }

  Future<void> _checkForQuizUpdates() async {
    try {
      final updateAvailable = await _quizRepository.isUpdateAvailable();
      if (updateAvailable) {
        _quizUpdateAvailableCallback();
      }
    } catch (e) {
      Fimber.e('Failed to determine if quiz updates are available.', ex: e);
    }
  }
}

typedef QuizUpdateAvailableCallback = void Function();
