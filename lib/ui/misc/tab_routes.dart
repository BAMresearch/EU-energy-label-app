/* * Copyright 2020 Bundesanstalt für Materialforschung und -prüfung (BAM) *
* Licensed under the EUPL, Version 1.2 or – as soon they will be approved by the European Commission - subsequent versions of the EUPL (the "Licence");
* You may not use this work except in compliance with theLicence.
* You may obtain a copy of the Licence at:
* * https://joinup.ec.europa.eu/software/page/eupl *
* Unless required by applicable law or agreed to in writing, software distributed under the Licence is distributed on an "AS IS" basis,
* WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
* See the Licence for the specific language governing permissions and limitations under the Licence.*/

import 'package:energielabel_app/ui/know_how/know_how_routes.dart';
import 'package:energielabel_app/ui/know_how/know_how_tab_specification.dart';

abstract class TabRoutes {
  TabRoutes._();

  static const String knowHow = 'knowHow';

  static Map<String, String>? withName;

  static TabRoute? getRoute(String? tabName, String? pageName) {
    switch (tabName) {
      case knowHow:
        return KnowHowRoutes.withName(pageName);
      default:
        return null;
    }
  }

  static Type? getSpecification(String? tabName) {
    switch (tabName) {
      case knowHow:
        return KnowHowTabSpecification;
      default:
        return null;
    }
  }
}

abstract class TabRoute {
  TabRoute._();

  String? route;
  Map<String, String>? withName;
}
