/* * Copyright 2020 Bundesanstalt für Materialforschung und -prüfung (BAM) *
* Licensed under the EUPL, Version 1.2 or – as soon they will be approved by the European Commission - subsequent versions of the EUPL (the "Licence");
* You may not use this work except in compliance with theLicence.
* You may obtain a copy of the Licence at:
* * https://joinup.ec.europa.eu/software/page/eupl *
* Unless required by applicable law or agreed to in writing, software distributed under the Licence is distributed on an "AS IS" basis,
* WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
* See the Licence for the specific language governing permissions and limitations under the Licence.*/

import 'package:energielabel_app/ui/favorites/pages/favorites_edit_page.dart';
import 'package:energielabel_app/ui/favorites/pages/favorites_page.dart';
import 'package:energielabel_app/ui/know_how/pages/label_guide/category_checklists_page.dart';
import 'package:energielabel_app/ui/know_how/pages/label_guide/category_tips_page.dart';
import 'package:energielabel_app/ui/misc/pages/csv_view_page.dart';
import 'package:energielabel_app/ui/misc/pages/pdf_view_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/translations.dart';

import 'favorites_routes.dart';

class FavoritesRouter {
  FavoritesRouter._();

  static Route<dynamic> onGenerateRoute(RouteSettings settings) {
    switch (settings.name) {
      case FavoritesRoutes.root:
        return MaterialPageRoute(builder: (context) => const FavoritesPage());
      case FavoritesRoutes.editFavorites:
        return MaterialPageRoute(
            builder: (context) =>
                FavoritesEditPage(favoriteEditArguments: settings.arguments as FavoritesEditArguments));
      case FavoritesRoutes.checklistDetails:
        return MaterialPageRoute(
            builder: (context) => CategoryChecklistsPage(
                categoryChecklistPageArguments: settings.arguments as CategoryChecklistPageArguments));
      case FavoritesRoutes.tipDetail:
        return MaterialPageRoute(
            builder: (context) => CategoryTipsPage(argument: settings.arguments as CategoryTipsPageArguments));
      case FavoritesRoutes.exportPdfPreview:
        return MaterialPageRoute(
          builder: (context) => PdfViewPage.fromPath(
              pageTitle: Translations.of(context)!.favorites_page_export_pdf_preview_title,
              pdfDocumentFolderPath: settings.arguments as String),
        );
      case FavoritesRoutes.exportCsvPreview:
        return MaterialPageRoute(
          builder: (context) => CsvViewPage(
            pageTitle: Translations.of(context)!.favorites_page_export_csv_preview_title,
            arguments: settings.arguments as CsvViewPageArguments,
          ),
        );
      default:
        throw ArgumentError.value(settings.name, null, 'Unexpected favorites route name.');
    }
  }
}
