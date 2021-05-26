/* * Copyright 2020 Bundesanstalt für Materialforschung und -prüfung (BAM) *
* Licensed under the EUPL, Version 1.2 or – as soon they will be approved by the European Commission - subsequent versions of the EUPL (the "Licence");
* You may not use this work except in compliance with theLicence.
* You may obtain a copy of the Licence at:
* * https://joinup.ec.europa.eu/software/page/eupl *
* Unless required by applicable law or agreed to in writing, software distributed under the Licence is distributed on an "AS IS" basis,
* WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
* See the Licence for the specific language governing permissions and limitations under the Licence.*/

import 'package:energielabel_app/ui/misc/tab_routes.dart';

class KnowHowRoutes implements TabRoute {
  KnowHowRoutes.withName(String routeName) {
    route = withName[routeName];
  }

  static const root = '/';
  static const glossary = '/glossary';
  static const labelGuideCategoriesOverview = '/label_guide_categories_overview';
  static const labelGuideCategoryOverview = '/label_guide_categories_overview/label_guide_category_overview';
  static const labelGuideCategoryChecklists =
      '/label_guide_categories_overview/label_guide_category_overview/checklists';
  static const labelGuideTips = '/label_guide_categories_overview/label_guide_category_overview/tips';
  static const labelGuideCategoryGuide = '/label_guide_categories_overview/label_guide_category_overview/guide';
  static const String whyIsThere = '/why_is_there';
  static const String regulations = '/regulations';
  static const String regulationDetails = '/regulations/details';

  @override
  Map<String, String> withName = {
    'glossary': glossary,
    'whyIsThere': whyIsThere,
    'labelGuideCategoriesOverview': labelGuideCategoriesOverview,
    'labelGuideCategoryChecklists': labelGuideCategoryChecklists,
  };

  @override
  String route;
}
