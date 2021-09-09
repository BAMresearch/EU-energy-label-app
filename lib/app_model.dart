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
import 'package:energielabel_app/initialization_exception.dart';
import 'package:energielabel_app/service_locator.dart';
import 'package:flutter/material.dart';
import 'package:flutter_fimber/flutter_fimber.dart';

/// 'View model'-like state class for the application.
///
/// On first build, the app calls [onAppStarted()] which triggers all upfront initialization.
/// Once all initialization is done AND the minimum initialization duration has passed,
/// the initialization is marked as finished. The actual app is now ready to run.
class AppModel extends ChangeNotifier {
  static const int _minInitializationDurationInSecs = 3;
  bool _initializationInProgress = true;
  bool _onboardingFinished = false;

  bool get isInitializing => _initializationInProgress;

  bool get isOnboardingFinished => _onboardingFinished;

  Future<void> onAppStarted(BuildContext context) async {
    try {
      await Future.wait([
        Future.delayed(Duration(seconds: _minInitializationDurationInSecs)),
        _initializeApp(context),
      ], eagerError: false);
    } catch (e, stacktrace) {
      Fimber.e('Failed to initialize app.', ex: e, stacktrace: stacktrace);
    } finally {
      _initializationInProgress = false;
      notifyListeners();
    }
  }

  Future<void> _initializeApp(BuildContext context) async {
    await _initializeDependencies(context);
    await _checkOnboarding();
    await _initializeNews();
    await _initializeQuiz();
  }

  Future<void> _initializeDependencies(BuildContext context) async {
    try {
      await ServiceLocator().registerDependencies(context);
    } catch (e) {
      throw InitializationException('Failed to initialize dependencies.', e);
    }
  }

  Future<void> _checkOnboarding() async {
    _onboardingFinished = ServiceLocator().get<SettingsRepository>()!.isOnboardingFinished();
  }

  Future<void> _initializeNews() async {
    try {
      await ServiceLocator().get<NewsRepository>()!.syncNews();
    } catch (e) {
      throw InitializationException('Failed to initialize the news.', e);
    }
  }

  Future<void> _initializeQuiz() async {
    try {
      await ServiceLocator().get<QuizRepository>()!.loadQuiz();
    } catch (e) {
      throw InitializationException('Failed to initialize the quiz.', e);
    }
  }
}
