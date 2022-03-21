/* * Copyright 2020 Bundesanstalt für Materialforschung und -prüfung (BAM) *
* Licensed under the EUPL, Version 1.2 or – as soon they will be approved by the European Commission - subsequent versions of the EUPL (the "Licence");
* You may not use this work except in compliance with theLicence.
* You may obtain a copy of the Licence at:
* * https://joinup.ec.europa.eu/software/page/eupl *
* Unless required by applicable law or agreed to in writing, software distributed under the Licence is distributed on an "AS IS" basis,
* WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
* See the Licence for the specific language governing permissions and limitations under the Licence.*/

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
import 'package:flutter/material.dart';

class HomeViewModel extends BaseViewModel {
  HomeViewModel({
    required BuildContext context,
  }) : _context = context;

  final BuildContext _context;

  @override
  void onViewStarted() {}

  void onLabelGuideTilePressed() {
    TabScaffold.of(_context)!.navigateIntoTab(KnowHowTabSpecification, KnowHowRoutes.labelGuideCategoriesOverview);
  }

  void onScannerTilePressed() {
    TabScaffold.of(_context)!.navigateIntoTab(ScannerTabSpecification, ScannerRoutes.root);
  }

  void onFavoriteTilePressed() {
    TabScaffold.of(_context)!.navigateIntoTab(FavoritesTabSpecification, FavoritesRoutes.root);
  }

  void onFirstStepsTilePressed() {
    TabScaffold.of(_context)!.navigateIntoTab(HomeTabSpecification, HomeRoutes.firstSteps);
  }

  void onQuizTilePressed() {
    TabScaffold.of(_context)!.navigateIntoTab(QuizTabSpecification, QuizRoutes.quizEntry);
  }
}

typedef QuizUpdateAvailableCallback = void Function();
