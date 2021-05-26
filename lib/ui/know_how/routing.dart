/* * Copyright 2020 Bundesanstalt für Materialforschung und -prüfung (BAM) *
* Licensed under the EUPL, Version 1.2 or – as soon they will be approved by the European Commission - subsequent versions of the EUPL (the "Licence");
* You may not use this work except in compliance with theLicence.
* You may obtain a copy of the Licence at:
* * https://joinup.ec.europa.eu/software/page/eupl *
* Unless required by applicable law or agreed to in writing, software distributed under the Licence is distributed on an "AS IS" basis,
* WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
* See the Licence for the specific language governing permissions and limitations under the Licence.*/

import 'package:energielabel_app/model/know_how/regulations/regulation.dart';
import 'package:energielabel_app/ui/know_how/know_how_routes.dart';
import 'package:energielabel_app/ui/know_how/pages/glossary/glossary_page.dart';
import 'package:energielabel_app/ui/know_how/pages/know_how_page.dart';
import 'package:energielabel_app/ui/know_how/pages/label_guide/categories_overview_page.dart';
import 'package:energielabel_app/ui/know_how/pages/label_guide/category_checklists_page.dart';
import 'package:energielabel_app/ui/know_how/pages/label_guide/category_guide_page.dart';
import 'package:energielabel_app/ui/know_how/pages/label_guide/category_overview_page.dart';
import 'package:energielabel_app/ui/know_how/pages/label_guide/category_tips_page.dart';
import 'package:energielabel_app/ui/know_how/pages/regulations/regulations_page.dart';
import 'package:energielabel_app/ui/know_how/pages/why_is_there/why_is_there_page.dart';
import 'package:energielabel_app/ui/misc/pages/pdf_view_page.dart';
import 'package:flutter/material.dart';

class KnowHowRouter {
  KnowHowRouter._();

  static Route<dynamic> onGenerateRoute(RouteSettings settings) {
    switch (settings.name) {
      case KnowHowRoutes.root:
        return MaterialPageRoute(builder: (context) => KnowHowPage());
      case KnowHowRoutes.glossary:
        return MaterialPageRoute(builder: (context) => GlossaryPage(initialSearchText: settings.arguments));
      case KnowHowRoutes.labelGuideCategoriesOverview:
        return MaterialPageRoute(builder: (context) => CategoriesOverviewPage());
      case KnowHowRoutes.labelGuideCategoryOverview:
        return MaterialPageRoute(builder: (context) => CategoryOverviewPage(labelCategory: settings.arguments));
      case KnowHowRoutes.labelGuideCategoryChecklists:
        return MaterialPageRoute(
            builder: (context) => CategoryChecklistsPage(categoryChecklistPageArguments: settings.arguments));
      case KnowHowRoutes.labelGuideTips:
        return MaterialPageRoute(builder: (context) => CategoryTipsPage(argument: settings.arguments));
      case KnowHowRoutes.labelGuideCategoryGuide:
        return MaterialPageRoute(builder: (context) => CategoryGuidePage(initialArguments: settings.arguments));
      case KnowHowRoutes.whyIsThere:
        return MaterialPageRoute(
            builder: (context) => WhyIsTherePage(initialIndex: int.parse(settings.arguments ?? '0')));
      case KnowHowRoutes.regulations:
        return MaterialPageRoute(builder: (context) => RegulationsPage());
      case KnowHowRoutes.regulationDetails:
        final Regulation regulation = settings.arguments;
        return MaterialPageRoute(
          builder: (context) => PdfViewPage.fromAssetPath(
            pageTitle: regulation.title,
            pdfAssetPath: regulation.pdfPath,
            isShareActionAllowed: true,
          ),
        );
      default:
        throw ArgumentError.value(settings.name, null, 'Unexpected know how route name.');
    }
  }
}
