/* * Copyright 2020 Bundesanstalt für Materialforschung und -prüfung (BAM) *
* Licensed under the EUPL, Version 1.2 or – as soon they will be approved by the European Commission - subsequent versions of the EUPL (the "Licence");
* You may not use this work except in compliance with theLicence.
* You may obtain a copy of the Licence at:
* * https://joinup.ec.europa.eu/software/page/eupl *
* Unless required by applicable law or agreed to in writing, software distributed under the Licence is distributed on an "AS IS" basis,
* WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
* See the Licence for the specific language governing permissions and limitations under the Licence.*/

import 'package:energielabel_app/data/asset_paths.dart';
import 'package:energielabel_app/ui/misc/html_utils.dart';
import 'package:energielabel_app/ui/misc/page_scaffold.dart';
import 'package:energielabel_app/ui/misc/pages/base_page.dart';
import 'package:energielabel_app/ui/misc/theme/bam_colors.dart';
import 'package:energielabel_app/ui/quiz/pages/quiz_result_view_model.dart';
import 'package:energielabel_app/ui/quiz/quiz_state.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/translations.dart';
import 'package:flutter_html/style.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:provider/provider.dart';

class QuizResultPage extends StatelessPage<QuizResultViewModel> {
  QuizResultPage({required this.quizState});

  final QuizState quizState;

  @override
  Widget build(BuildContext context) {
    return PageScaffold(
      automaticallyImplyLeading: false,
      title: quizState.title,
      body: ChangeNotifierProvider<QuizResultViewModel>(
        create: (context) => createViewModel(context),
        child: Consumer<QuizResultViewModel>(
          builder: (context, viewModel, child) => Stack(
            children: [
              SvgPicture.asset(AssetPaths.quizResultBackgroundImage),
              Column(
                children: [
                  LinearProgressIndicator(
                    backgroundColor: BamColorPalette.bamWhite,
                    value: 1,
                    minHeight: 8,
                  ),
                  Expanded(
                    child: SingleChildScrollView(
                      child: Column(
                        children: [
                          SizedBox(height: 30),
                          Text(
                            Translations.of(context)!
                                .quiz_result_score_label(
                                  viewModel.correctAnswers.toString(),
                                  viewModel.maxIndex.toString(),
                                )
                                .toUpperCase(),
                            style: Theme.of(context)
                                .textTheme
                                .bodyText2!
                                .copyWith(color: BamColorPalette.bamBlack45Optimized),
                          ),
                          SizedBox(height: 24),
                          Padding(
                            padding: EdgeInsets.symmetric(horizontal: 16),
                            child: Text(
                              viewModel.isResultPositive
                                  ? Translations.of(context)!.quiz_result_label_good
                                  : Translations.of(context)!.quiz_result_label_bad,
                              textAlign: TextAlign.center,
                              style: Theme.of(context).textTheme.headline1!.copyWith(color: BamColorPalette.bamGreen4),
                            ),
                          ),
                          SizedBox(height: 24),
                          SvgPicture.asset(viewModel.isResultPositive
                              ? AssetPaths.quizResultCupGoldImage
                              : AssetPaths.quizResultCupSilverImage),
                          SizedBox(height: 40),
                          Padding(
                            padding: EdgeInsets.symmetric(horizontal: 16),
                            child: HtmlUtils.stringToHtml(context,
                                viewModel.isResultPositive ? viewModel.positiveResult : viewModel.negativeResult,
                                customStyle: {
                                  '*': Style.fromTextStyle(Theme.of(context).textTheme.subtitle1!)
                                      .copyWith(color: BamColorPalette.bamBlack80),
                                }),
                          ),
                          SizedBox(height: 16),
                        ],
                      ),
                    ),
                  ),
                  ElevatedButton(
                    style: ButtonStyle(
                      minimumSize: MaterialStateProperty.all(Size(double.maxFinite, 60)),
                      shape: MaterialStateProperty.all(RoundedRectangleBorder()),
                    ),
                    onPressed: viewModel.onReplyButtonTapped,
                    child: Text(Translations.of(context)!.quiz_replay_button.toUpperCase()),
                  )
                ],
              )
            ],
          ),
        ),
      ),
    );
  }

  @override
  QuizResultViewModel createViewModel(BuildContext context) {
    return QuizResultViewModel(quizState: quizState, context: context);
  }
}
