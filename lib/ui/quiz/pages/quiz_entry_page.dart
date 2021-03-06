/* * Copyright 2020 Bundesanstalt für Materialforschung und -prüfung (BAM) *
* Licensed under the EUPL, Version 1.2 or – as soon they will be approved by the European Commission - subsequent versions of the EUPL (the "Licence");
* You may not use this work except in compliance with theLicence.
* You may obtain a copy of the Licence at:
* * https://joinup.ec.europa.eu/software/page/eupl *
* Unless required by applicable law or agreed to in writing, software distributed under the Licence is distributed on an "AS IS" basis,
* WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
* See the Licence for the specific language governing permissions and limitations under the Licence.*/

import 'package:energielabel_app/data/quiz_repository.dart';
import 'package:energielabel_app/service_locator.dart';
import 'package:energielabel_app/ui/misc/components/item_button.dart';
import 'package:energielabel_app/ui/misc/page_scaffold.dart';
import 'package:energielabel_app/ui/misc/pages/base_page.dart';
import 'package:energielabel_app/ui/misc/theme/bam_colors.dart';
import 'package:energielabel_app/ui/quiz/pages/quiz_entry_view_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:provider/provider.dart';

class QuizEntryPage extends StatelessPage<QuizEntryViewModel> {
  const QuizEntryPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<QuizEntryViewModel>(
      create: (context) => createViewModel(context)..onViewStarted(),
      child: Consumer<QuizEntryViewModel>(builder: (context, viewModel, staticChild) {
        return PageScaffold(
          title: viewModel.quizTitle,
          body: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  const SizedBox(height: 16),

                  // The quiz description
                  Html(
                    data: viewModel.quizDescription,
                    style: {
                      'body': Style(color: BamColorPalette.bamBlack80, margin: EdgeInsets.zero),
                    },
                  ),

                  const SizedBox(height: 32),

                  // The level buttons
                  ...viewModel.levels!
                      .map((level) => Column(
                            children: [
                              ItemButton.fromIconString(
                                label: level.name!,
                                iconString: level.icon!,
                                textStyle:
                                    Theme.of(context).textTheme.headline3!.copyWith(color: BamColorPalette.bamBlue3),
                                onTap: () => viewModel.onLevelSelected(level),
                              ),
                              const SizedBox(height: 16)
                            ],
                          ))
                      .toList(),
                ],
              ),
            ),
          ),
        );
      }),
    );
  }

  @override
  QuizEntryViewModel createViewModel(BuildContext context) {
    return QuizEntryViewModel(context: context, quizRepository: ServiceLocator().get<QuizRepository>()!);
  }
}
