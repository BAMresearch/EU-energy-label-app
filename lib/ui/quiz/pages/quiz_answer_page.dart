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
import 'package:energielabel_app/ui/misc/theme/bam_colors.dart';
import 'package:energielabel_app/ui/quiz/pages/quiz_answer_view_model.dart';
import 'package:energielabel_app/ui/quiz/quiz_state.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/translations.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:provider/provider.dart';

class QuizAnswerPage extends StatelessPage<QuizAnswerViewModel> {
  QuizAnswerPage({required this.quizState});

  final QuizState quizState;

  @override
  Widget build(BuildContext context) {
    return PageScaffold(
      title: quizState.title,
      automaticallyImplyLeading: false,
      body: ChangeNotifierProvider<QuizAnswerViewModel>(
        create: (context) => createViewModel(context),
        child: Consumer<QuizAnswerViewModel>(
          builder: (context, viewModel, staticChild) => Column(
            children: [
              LinearProgressIndicator(
                value: viewModel.progress,
                backgroundColor: BamColorPalette.bamWhite,
                minHeight: 8,
                semanticsValue: Translations.of(context)!.quiz_answer_count_label(
                  viewModel.currentIndex.toString(),
                  viewModel.maxIndex.toString(),
                ),
              ),
              Expanded(
                child: SingleChildScrollView(
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        SizedBox(
                          width: double.maxFinite,
                          child: Column(
                            children: [
                              Padding(
                                padding: const EdgeInsets.symmetric(vertical: 8),
                                child: Text(
                                  Translations.of(context)!
                                      .quiz_answer_count_label(
                                        viewModel.currentIndex.toString(),
                                        viewModel.maxIndex.toString(),
                                      )
                                      .toUpperCase(),
                                  style: Theme.of(context)
                                      .textTheme
                                      .bodyText2!
                                      .copyWith(color: BamColorPalette.bamBlack45Optimized),
                                ),
                              ),
                              SizedBox(height: 16),
                              MergeSemantics(
                                child: Column(
                                  children: [
                                    Text(
                                      viewModel.isCurrentAnswerCorrect!
                                          ? Translations.of(context)!.quiz_answer_congratulation_label
                                          : Translations.of(context)!.quiz_answer_you_are_wrong_label,
                                      textAlign: TextAlign.center,
                                      style: Theme.of(context).textTheme.headline1!.copyWith(
                                          color: viewModel.isCurrentAnswerCorrect!
                                              ? BamColorPalette.bamGreen3
                                              : BamColorPalette.bamRed1),
                                    ),
                                    SizedBox(height: 16),
                                    SvgPicture.asset(
                                      viewModel.isCurrentAnswerCorrect!
                                          ? AssetPaths.quizCorrectAnswerIcon
                                          : AssetPaths.quizWrongAnswerIcon,
                                      semanticsLabel: viewModel.isCurrentAnswerCorrect!
                                          ? Translations.of(context)!.quiz_answer_congratulation_image_semantics
                                          : Translations.of(context)!.quiz_answer_you_are_wrong_image_semantics,
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(vertical: 32),
                          child: Text(
                            Translations.of(context)!.quiz_answer_explanation_header_label,
                            style: Theme.of(context).textTheme.subtitle1!.copyWith(color: BamColorPalette.bamBlack80),
                          ),
                        ),
                        Text(
                          viewModel.answerText!,
                          style: Theme.of(context).textTheme.subtitle1!.copyWith(color: BamColorPalette.bamBlack80),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              ElevatedButton(
                style: ButtonStyle(
                  minimumSize: MaterialStateProperty.all(Size(double.maxFinite, 60)),
                  shape: MaterialStateProperty.all(RoundedRectangleBorder()),
                  backgroundColor: MaterialStateProperty.all(BamColorPalette.bamBlue1),
                ),
                onPressed: () {
                  viewModel.onNextButtonTapped(context);
                },
                child: Text(
                  Translations.of(context)!.quiz_next_button.toUpperCase(),
                  style: Theme.of(context).textTheme.button!.copyWith(color: BamColorPalette.bamWhite),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

  @override
  QuizAnswerViewModel createViewModel(BuildContext context) {
    return QuizAnswerViewModel(quizState: quizState);
  }
}
