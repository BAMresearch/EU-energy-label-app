/* * Copyright 2020 Bundesanstalt für Materialforschung und -prüfung (BAM) *
* Licensed under the EUPL, Version 1.2 or – as soon they will be approved by the European Commission - subsequent versions of the EUPL (the "Licence");
* You may not use this work except in compliance with theLicence.
* You may obtain a copy of the Licence at:
* * https://joinup.ec.europa.eu/software/page/eupl *
* Unless required by applicable law or agreed to in writing, software distributed under the Licence is distributed on an "AS IS" basis,
* WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
* See the Licence for the specific language governing permissions and limitations under the Licence.*/

import 'dart:async';

import 'package:energielabel_app/app_entry_routes.dart';
import 'package:energielabel_app/data/settings_repository.dart';
import 'package:energielabel_app/ui/misc/pages/base_view_model.dart';
import 'package:flutter/material.dart';
import 'package:pedantic/pedantic.dart';

class OnboardingViewModel extends BaseViewModel {
  OnboardingViewModel({
    required BuildContext context,
    required SettingsRepository settingsRepository,
  })   : _context = context,
        _settingsRepository = settingsRepository;

  static const int _pageCount = 5;

  final BuildContext _context;
  final SettingsRepository _settingsRepository;
  int _currentPageIndex = 0;

  int get pageCount => _pageCount;

  int get currentPageIndex => _currentPageIndex;

  bool get isLastPage => _currentPageIndex == _pageCount - 1;

  @override
  FutureOr<void> onViewStarted() {}

  void onCompleteAction() {
    unawaited(_settingsRepository.setOnboardingFinished(true));
    Navigator.of(_context).pushReplacementNamed(AppEntryRoutes.main);
  }

  void onPageChangeAction(int index) {
    _currentPageIndex = index;
    notifyListeners();
  }
}
