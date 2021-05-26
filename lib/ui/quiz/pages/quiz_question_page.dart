/* * Copyright 2020 Bundesanstalt für Materialforschung und -prüfung (BAM) *
* Licensed under the EUPL, Version 1.2 or – as soon they will be approved by the European Commission - subsequent versions of the EUPL (the "Licence");
* You may not use this work except in compliance with theLicence.
* You may obtain a copy of the Licence at:
* * https://joinup.ec.europa.eu/software/page/eupl *
* Unless required by applicable law or agreed to in writing, software distributed under the Licence is distributed on an "AS IS" basis,
* WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
* See the Licence for the specific language governing permissions and limitations under the Licence.*/

import 'package:energielabel_app/ui/misc/page_scaffold.dart';
import 'package:energielabel_app/ui/misc/pages/base_page.dart';
import 'package:energielabel_app/ui/misc/quiz_question_button.dart';
import 'package:energielabel_app/ui/misc/theme/bam_colors.dart';
import 'package:energielabel_app/ui/quiz/pages/quiz_question_view_model.dart';
import 'package:energielabel_app/ui/quiz/quiz_state.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/translations.dart';
import 'package:provider/provider.dart';

class QuizQuestionPage extends StatelessPage<QuizQuestionViewModel> {
  QuizQuestionPage({@required this.quizState}) : assert(quizState != null);

  final QuizState quizState;

  @override
  Widget build(BuildContext context) {
    return PageScaffold(
      title: quizState.title,
      automaticallyImplyLeading: false,
      body: ChangeNotifierProvider<QuizQuestionViewModel>(
        create: (context) => createViewModel(context)..onViewStarted(),
        child: Consumer<QuizQuestionViewModel>(builder: (context, viewModel, staticChild) {
          return Column(
            children: [
              LinearProgressIndicator(
                backgroundColor: BamColorPalette.bamWhite,
                value: viewModel.progress,
                minHeight: 8,
                semanticsValue: Translations.of(context)
                    .quiz_question_label(viewModel.currentIndex.toString(), viewModel.maxIndex.toString()),
              ),
              Expanded(
                child: SingleChildScrollView(
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Padding(
                          padding: const EdgeInsets.symmetric(vertical: 8),
                          child: Text(
                            Translations.of(context)
                                .quiz_question_label(viewModel.currentIndex.toString(), viewModel.maxIndex.toString())
                                .toUpperCase(),
                            style: Theme.of(context)
                                .textTheme
                                .bodyText2
                                .copyWith(color: BamColorPalette.bamBlack45Optimized),
                          ),
                        ),
                        SizedBox(height: 16),
                        Text(
                          viewModel.questionText,
                          textAlign: TextAlign.center,
                          style: Theme.of(context).textTheme.headline1.copyWith(color: BamColorPalette.bamBlue3),
                        ),
                        Visibility(
                          visible: false,
                          child: Image.network(''),
                        ),
                        Visibility(
                          visible: false,
                          child: Image.network(''),
                        ),
                        SizedBox(height: 16),
                        ...viewModel.quizState.currentQuestion.answers
                            .map((answerOption) => Padding(
                                  padding: EdgeInsets.symmetric(vertical: 8),
                                  child: RadioButton(
                                      caption: answerOption.title,
                                      value: answerOption,
                                      groupValue: viewModel.selectedAnswer,
                                      onChanged: viewModel.onAnswerSelected),
                                ))
                            .toList(),
                      ],
                    ),
                  ),
                ),
              ),
              ElevatedButton(
                style: ButtonStyle(
                  minimumSize: MaterialStateProperty.all(Size(double.maxFinite, 60)),
                  shape: MaterialStateProperty.all(RoundedRectangleBorder()),
                  backgroundColor: MaterialStateProperty.all(
                      viewModel.selectedAnswer == null ? BamColorPalette.bamBlue3 : BamColorPalette.bamBlue1),
                ),
                onPressed: viewModel.selectedAnswer == null ? null : () => viewModel.onTouchNextButton(context),
                child: Text(
                  Translations.of(context).quiz_next_button.toUpperCase(),
                  style: Theme.of(context).textTheme.button.copyWith(
                      color: viewModel.selectedAnswer == null
                          ? BamColorPalette.bamWhite.withOpacity(0.5)
                          : BamColorPalette.bamWhite),
                ),
              )
            ],
          );
        }),
      ),
    );
  }

  @override
  QuizQuestionViewModel createViewModel(BuildContext context) {
    return QuizQuestionViewModel(quizState: quizState);
  }
}
