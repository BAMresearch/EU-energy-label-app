/* * Copyright 2020 Bundesanstalt für Materialforschung und -prüfung (BAM) *
* Licensed under the EUPL, Version 1.2 or – as soon they will be approved by the European Commission - subsequent versions of the EUPL (the "Licence");
* You may not use this work except in compliance with theLicence.
* You may obtain a copy of the Licence at:
* * https://joinup.ec.europa.eu/software/page/eupl *
* Unless required by applicable law or agreed to in writing, software distributed under the Licence is distributed on an "AS IS" basis,
* WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
* See the Licence for the specific language governing permissions and limitations under the Licence.*/

import 'package:energielabel_app/app_entry_routes.dart';
import 'package:energielabel_app/app_model.dart';
import 'package:energielabel_app/ui/favorites/favorites_tab_specification.dart';
import 'package:energielabel_app/ui/home/home_tab_specification.dart';
import 'package:energielabel_app/ui/know_how/know_how_tab_specification.dart';
import 'package:energielabel_app/ui/misc/tab_scaffold.dart';
import 'package:energielabel_app/ui/misc/tab_specification.dart';
import 'package:energielabel_app/ui/misc/theme/bam_app_theme.dart';
import 'package:energielabel_app/ui/onboarding/pages/onboarding_page.dart';
import 'package:energielabel_app/ui/quiz/quiz_tab_specification.dart';
import 'package:energielabel_app/ui/scanner/scanner_tab_specification.dart';
import 'package:energielabel_app/ui/splash/splash_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/translations.dart';
import 'package:provider/provider.dart';

/// The BAM application.
///
/// Shows [SplashPage] while the upfront initialization is in progress and replaces
/// it with the actual MaterialApp once finished.
class App extends StatefulWidget {
  const App({Key? key}) : super(key: key);

  // Holding the list of TabSpecifications so that they're build just once.
  // Otherwise, whenever a new TabSpecification is created, a new GlobalKey is created for
  // each TabNavigator, which makes Flutter think these are different widgets and recreates their state.
  @override
  _AppState createState() => _AppState();
}

class _AppState extends State<App> {
  final List<TabSpecification> _tabSpecifications = [];
  final AppModel _appModel = AppModel();

  @override
  void initState() {
    WidgetsBinding.instance!.addPostFrameCallback((_) {
      _appModel.onAppStarted(context);
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<AppModel>.value(
      value: _appModel,
      child: Consumer<AppModel>(
        builder: (context, appModel, _) {
          if (appModel.isInitializing) {
            return const SplashPage();
          }
          return MaterialApp(
            theme: BamTheme.themeData,
            localizationsDelegates: Translations.localizationsDelegates,
            supportedLocales: Translations.supportedLocales,
            initialRoute: appModel.isOnboardingFinished ? AppEntryRoutes.main : AppEntryRoutes.onboarding,
            builder: (context, widget) {
              // Create the tab specifications with the localization-aware context.
              _createTabSpecifications(context);
              return widget!;
            },
            routes: {
              AppEntryRoutes.onboarding: (context) => const OnboardingPage(showSkipButton: true),
              AppEntryRoutes.main: (context) => TabScaffold(tabSpecifications: _tabSpecifications),
            },
          );
        },
      ),
    );
  }

  void _createTabSpecifications(BuildContext context) {
    if (_tabSpecifications.isEmpty) {
      _tabSpecifications.addAll([
        HomeTabSpecification(context),
        KnowHowTabSpecification(context),
        ScannerTabSpecification(context),
        QuizTabSpecification(context),
        FavoritesTabSpecification(context),
      ]);
    }
  }
}
