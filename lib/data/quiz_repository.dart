/* * Copyright 2020 Bundesanstalt für Materialforschung und -prüfung (BAM) *
* Licensed under the EUPL, Version 1.2 or – as soon they will be approved by the European Commission - subsequent versions of the EUPL (the "Licence");
* You may not use this work except in compliance with theLicence.
* You may obtain a copy of the Licence at:
* * https://joinup.ec.europa.eu/software/page/eupl *
* Unless required by applicable law or agreed to in writing, software distributed under the Licence is distributed on an "AS IS" basis,
* WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
* See the Licence for the specific language governing permissions and limitations under the Licence.*/

import 'dart:convert';

import 'package:energielabel_app/data/api/bam_api_client.dart';
import 'package:energielabel_app/data/asset_paths.dart';
import 'package:energielabel_app/data/persistence/quiz_dao.dart';
import 'package:energielabel_app/data/repository_exception.dart';
import 'package:energielabel_app/data/settings_repository.dart';
import 'package:energielabel_app/device_info.dart';
import 'package:energielabel_app/model/localized_quiz.dart';
import 'package:energielabel_app/model/quiz/quiz.dart';
import 'package:flutter/services.dart';
import 'package:flutter_fimber/flutter_fimber.dart';
import 'package:optional/optional.dart';

class QuizRepository {
  QuizRepository(
    SettingsRepository settingsRepository,
    QuizDao quizDao,
    BamApiClient apiClient,
    AssetBundle assetBundle,
    DeviceInfo deviceInfo,
  )   : assert(settingsRepository != null),
        assert(quizDao != null),
        assert(apiClient != null),
        assert(assetBundle != null),
        assert(deviceInfo != null),
        _settingsRepository = settingsRepository,
        _quizDao = quizDao,
        _apiClient = apiClient,
        _assetBundle = assetBundle,
        _deviceInfo = deviceInfo;

  final SettingsRepository _settingsRepository;
  final QuizDao _quizDao;
  final BamApiClient _apiClient;
  final AssetBundle _assetBundle;
  final DeviceInfo _deviceInfo;

  Future<bool> isUpdateAvailable() async {
    final bool deferredUpdateAvailable = _settingsRepository.isDeferredQuizUpdateAvailable();

    if (!deferredUpdateAvailable) {
      final String quizUpdateHash = await _apiClient.fetchQuizUpdatableInfo(_deviceInfo.bestMatchedLocale.languageCode);
      final localQuizUpdateHash = _settingsRepository.getQuizVersionHash() ?? '';
      return localQuizUpdateHash != quizUpdateHash;
    }
    return true;
  }

  Future<Quiz> loadQuiz() async {
    try {
      final deviceLanguage = _deviceInfo.bestMatchedLocale.languageCode;

      final Optional<LocalizedQuiz> storedQuiz = _quizDao.loadQuiz();
      if (storedQuiz.isPresent) {
        if (storedQuiz.value.language == deviceLanguage) {
          return storedQuiz.value.quiz;
        }

        try {
          final syncedQuiz = await syncQuiz();
          return syncedQuiz;
        } catch (e) {
          Fimber.w('Failed to sync quiz.', ex: e);
        }
      }

      final Quiz quiz = await _loadQuizFromAssets();
      final Map<String, String> initialETag = {
        'de': '"697103e109dfd972ab8892f2f4e78605"',
        'en': '"1a14005401fb5466fee02db7dfea1a8d"',
      };
      await _settingsRepository.setQuizVersionHash(initialETag[deviceLanguage] ?? '');
      await _quizDao.saveQuiz(quiz, deviceLanguage);
      return quiz;
    } catch (e) {
      throw RepositoryException('Failed to load the quiz.', e);
    }
  }

  Future<Quiz> syncQuiz() async {
    try {
      final deviceLanguage = _deviceInfo.bestMatchedLocale.languageCode;
      final Quiz quiz = await _apiClient.fetchQuiz(
          deviceLanguage, (String etag) async => await _settingsRepository.setQuizVersionHash(etag));
      await _quizDao.saveQuiz(quiz, deviceLanguage);

      return quiz;
    } catch (e) {
      throw RepositoryException('Failed to synchronize the quiz.', e);
    }
  }

  Future<Quiz> _loadQuizFromAssets() async {
    try {
      final assetJson = await _assetBundle.loadString(AssetPaths.quizJson(_deviceInfo.bestMatchedLocale));
      return Quiz.fromJson(jsonDecode(assetJson));
    } catch (e) {
      throw RepositoryException('Failed to load quiz from local assets.', e);
    }
  }
}
