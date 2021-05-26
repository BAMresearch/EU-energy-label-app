/* * Copyright 2020 Bundesanstalt für Materialforschung und -prüfung (BAM) *
* Licensed under the EUPL, Version 1.2 or – as soon they will be approved by the European Commission - subsequent versions of the EUPL (the "Licence");
* You may not use this work except in compliance with theLicence.
* You may obtain a copy of the Licence at:
* * https://joinup.ec.europa.eu/software/page/eupl *
* Unless required by applicable law or agreed to in writing, software distributed under the Licence is distributed on an "AS IS" basis,
* WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
* See the Licence for the specific language governing permissions and limitations under the Licence.*/

import 'package:flutter/widgets.dart';

abstract class TabSpecification {
  TabSpecification({
    @required this.label,
    @required this.iconAssetPath,
    @required this.onGenerateRoute,
  })  : assert(label != null),
        assert(iconAssetPath != null),
        assert(onGenerateRoute != null);

  final GlobalKey<NavigatorState> tabNavigatorKey = GlobalKey<NavigatorState>();
  final String label;
  final String iconAssetPath;
  final RouteFactory onGenerateRoute;
}