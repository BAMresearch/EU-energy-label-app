/* * Copyright 2020 Bundesanstalt für Materialforschung und -prüfung (BAM) *
* Licensed under the EUPL, Version 1.2 or – as soon they will be approved by the European Commission - subsequent versions of the EUPL (the "Licence");
* You may not use this work except in compliance with theLicence.
* You may obtain a copy of the Licence at:
* * https://joinup.ec.europa.eu/software/page/eupl *
* Unless required by applicable law or agreed to in writing, software distributed under the Licence is distributed on an "AS IS" basis,
* WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
* See the Licence for the specific language governing permissions and limitations under the Licence.*/

import 'package:energielabel_app/data/asset_paths.dart';
import 'package:energielabel_app/ui/misc/page_scaffold.dart';
import 'package:energielabel_app/ui/misc/pages/base_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/translations.dart';
import 'package:flutter_svg/svg.dart';
import 'package:provider/provider.dart';

import 'csv_view_view_model.dart';

class CsvViewPageArguments {
  CsvViewPageArguments({required this.csvPath, required this.previewContent});

  final String csvPath;
  final List<List<String>> previewContent;
}

class CsvViewPage extends StatelessPage<CsvViewViewModel> {
  CsvViewPage({
    Key? key,
    required CsvViewPageArguments arguments,
    required this.pageTitle,
  })  : csvPath = arguments.csvPath,
        previewContent = arguments.previewContent,
        super(key: key);

  final String pageTitle;
  final String csvPath;
  final List<List<String>> previewContent;
  final _shareButtonKey = GlobalKey();

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<CsvViewViewModel>(
      create: (context) => createViewModel(context)..onViewStarted(),
      child: Consumer<CsvViewViewModel>(
        builder: (context, viewModel, _) => PageScaffold(
            actions: [
              IconButton(
                key: _shareButtonKey,
                icon: SvgPicture.asset(
                  AssetPaths.shareIcon,
                  semanticsLabel: Translations.of(context)!.share_page_share_button,
                ),
                onPressed: () => viewModel.onShareContent(context),
              )
            ],
            title: pageTitle,
            body: SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: SingleChildScrollView(
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Table(
                      border: TableBorder.all(),
                      columnWidths: <int, TableColumnWidth>{
                        for (int column = 0; column < previewContent.first.length; column += 1)
                          column: const FixedColumnWidth(200.0),
                      },
                      children: previewContent
                          .map(
                            (List<String> rows) => TableRow(
                                children: rows
                                    .map(
                                      (String cellText) => TableCell(
                                        child: Padding(
                                          padding: const EdgeInsets.all(8.0),
                                          child: SizedBox(
                                            child: Text(cellText),
                                          ),
                                        ),
                                      ),
                                    )
                                    .toList()),
                          )
                          .toList()),
                ),
              ),
            )),
      ),
    );
  }

  @override
  CsvViewViewModel createViewModel(BuildContext context) => CsvViewViewModel(
        csvPath: csvPath,
        shareButtonKey: _shareButtonKey,
      );
}
