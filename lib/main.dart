/* * Copyright 2020 Bundesanstalt für Materialforschung und -prüfung (BAM) *
* Licensed under the EUPL, Version 1.2 or – as soon they will be approved by the European Commission - subsequent versions of the EUPL (the "Licence");
* You may not use this work except in compliance with theLicence.
* You may obtain a copy of the Licence at:
* * https://joinup.ec.europa.eu/software/page/eupl *
* Unless required by applicable law or agreed to in writing, software distributed under the Licence is distributed on an "AS IS" basis,
* WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
* See the Licence for the specific language governing permissions and limitations under the Licence.*/

import 'package:energielabel_app/app.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_fimber/flutter_fimber.dart';

/// Class holding the basic app configuration.
///
/// To run the app, specify the following environment variables:
///
/// - --dart-define=ENVIRONMENT=(one of dev, int, staging, prod)
/// - --dart-define=BACKEND_URL=...  (urlEncoded)
/// - --dart-define=API_KEY=... (urlEncoded)
class AppConfig {
  static const environment = String.fromEnvironment('ENVIRONMENT');
  static const backendURL = String.fromEnvironment('BACKEND_URL');
  static const apiKey = String.fromEnvironment('API_KEY');
}

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]);
  _setupLogging();

  runApp(App());
}

void _setupLogging() {
  if (kDebugMode) {
    final logLevels = List.of(DebugTree.defaultLevels)..add('V');
    Fimber.plantTree(DebugTree(logLevels: logLevels));
  }
}
