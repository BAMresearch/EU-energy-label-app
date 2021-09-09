/* * Copyright 2020 Bundesanstalt für Materialforschung und -prüfung (BAM) *
* Licensed under the EUPL, Version 1.2 or – as soon they will be approved by the European Commission - subsequent versions of the EUPL (the "Licence");
* You may not use this work except in compliance with theLicence.
* You may obtain a copy of the Licence at:
* * https://joinup.ec.europa.eu/software/page/eupl *
* Unless required by applicable law or agreed to in writing, software distributed under the Licence is distributed on an "AS IS" basis,
* WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
* See the Licence for the specific language governing permissions and limitations under the Licence.*/

import 'package:energielabel_app/ui/home/pages/home_page.dart';
import 'package:energielabel_app/ui/infothek/about_app_page.dart';
import 'package:energielabel_app/ui/infothek/app_license_page.dart';
import 'package:energielabel_app/ui/infothek/first_steps_page.dart';
import 'package:energielabel_app/ui/misc/pages/html_content_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/translations.dart';

class HomeRoutes {
  HomeRoutes._();

  static const String root = '/';
  static const String aboutApp = '/about_app';
  static const String aboutAppLicense = '/about_app/license';
  static const String imprint = '/imprint';
  static const String privacyPolicy = '/privacy_policy';
  static const String firstSteps = '/first_steps';
}

class HomeRouter {
  HomeRouter._();

  static Route<dynamic> onGenerateRoute(RouteSettings settings) {
    switch (settings.name) {
      case HomeRoutes.root:
        return MaterialPageRoute(builder: (context) => HomePage());
      case HomeRoutes.imprint:
        return MaterialPageRoute(
          builder: (context) => HtmlContentPage(
              htmlAssetPath: settings.arguments as String, pageTitle: Translations.of(context)!.imprint_page_title),
        );
      case HomeRoutes.aboutApp:
        return MaterialPageRoute(builder: (context) => AboutAppPage());
      case HomeRoutes.aboutAppLicense:
        return MaterialPageRoute(builder: (context) => AppLicensePage());
      case HomeRoutes.privacyPolicy:
        return MaterialPageRoute(
          builder: (context) => HtmlContentPage(
              htmlAssetPath: settings.arguments as String, pageTitle: Translations.of(context)!.privacy_policy_title),
        );
      case HomeRoutes.firstSteps:
        return MaterialPageRoute(builder: (context) => FirstSteps());
      default:
        throw ArgumentError.value(settings.name, null, 'Unexpected home route name.');
    }
  }
}
