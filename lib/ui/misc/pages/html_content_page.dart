/* * Copyright 2020 Bundesanstalt für Materialforschung und -prüfung (BAM) *
* Licensed under the EUPL, Version 1.2 or – as soon they will be approved by the European Commission - subsequent versions of the EUPL (the "Licence");
* You may not use this work except in compliance with theLicence.
* You may obtain a copy of the Licence at:
* * https://joinup.ec.europa.eu/software/page/eupl *
* Unless required by applicable law or agreed to in writing, software distributed under the Licence is distributed on an "AS IS" basis,
* WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
* See the Licence for the specific language governing permissions and limitations under the Licence.*/

import 'package:energielabel_app/ui/misc/html_utils.dart';
import 'package:energielabel_app/ui/misc/page_scaffold.dart';
import 'package:energielabel_app/ui/misc/pages/base_page.dart';
import 'package:energielabel_app/ui/misc/pages/html_content_view_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_html/style.dart';
import 'package:provider/provider.dart';

class HtmlContentPage extends StatelessPage<HtmlContentViewModel> {
  HtmlContentPage({required this.htmlAssetPath, required this.pageTitle});

  final String pageTitle;
  final String htmlAssetPath;

  @override
  Widget build(BuildContext context) {
    return PageScaffold(
      title: pageTitle,
      body: ChangeNotifierProvider<HtmlContentViewModel>(
        create: (context) => createViewModel(context)..onViewStarted(),
        child: Consumer<HtmlContentViewModel>(
          builder: (context, viewModel, _) {
            if (viewModel.isContentUrlAvailable && viewModel.isContentLoaded) {
              return Stack(
                children: [
                  Scrollbar(
                    child: SingleChildScrollView(
                      child: HtmlUtils.stringToHtml(
                        context,
                        viewModel.htmlContent,
                        customStyle: {
                          'body': Style(
                            margin: const EdgeInsets.fromLTRB(20, 34, 20, 20),
                          ),
                        },
                      ),
                    ),
                  ),
                ],
              );
            } else {
              return SizedBox.shrink();
            }
          },
        ),
      ),
    );
  }

  @override
  HtmlContentViewModel createViewModel(BuildContext context) => HtmlContentViewModel(htmlAssetPath: htmlAssetPath);
}
