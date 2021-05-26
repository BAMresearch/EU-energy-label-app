/* * Copyright 2020 Bundesanstalt für Materialforschung und -prüfung (BAM) *
* Licensed under the EUPL, Version 1.2 or – as soon they will be approved by the European Commission - subsequent versions of the EUPL (the "Licence");
* You may not use this work except in compliance with theLicence.
* You may obtain a copy of the Licence at:
* * https://joinup.ec.europa.eu/software/page/eupl *
* Unless required by applicable law or agreed to in writing, software distributed under the Licence is distributed on an "AS IS" basis,
* WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
* See the Licence for the specific language governing permissions and limitations under the Licence.*/

import 'package:dots_indicator/dots_indicator.dart';
import 'package:energielabel_app/data/asset_paths.dart';
import 'package:energielabel_app/data/settings_repository.dart';
import 'package:energielabel_app/service_locator.dart';
import 'package:energielabel_app/ui/misc/components/multi_cross_fade_animation.dart';
import 'package:energielabel_app/ui/misc/pages/base_page.dart';
import 'package:energielabel_app/ui/misc/theme/bam_colors.dart';
import 'package:energielabel_app/ui/misc/theme/bam_text_theme.dart';
import 'package:energielabel_app/ui/onboarding/components/onboarding_content.dart';
import 'package:energielabel_app/ui/onboarding/pages/onboarding_view_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/translations.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:provider/provider.dart';
import 'package:responsive_layout_builder/responsive_layout_builder.dart';

class OnboardingPage extends StatelessPage<OnboardingViewModel> {
  OnboardingPage({Key key, this.showSkipButton = true});

  final bool showSkipButton;

  List<OnboardingItem> _onBoardingContent(BuildContext context) => [
        OnboardingItem(
          Translations.of(context).onboarding_page_1_title,
          null,
          Translations.of(context).onboarding_page_1_description,
          null,
        ),
        OnboardingItem(
          Translations.of(context).onboarding_page_2_title,
          null,
          Translations.of(context).onboarding_page_2_description,
          null,
        ),
        OnboardingItem(
          Translations.of(context).onboarding_page_3_title,
          Translations.of(context).onboarding_page_3_title_semantic,
          Translations.of(context).onboarding_page_3_description,
          null,
        ),
        OnboardingItem(
          Translations.of(context).onboarding_page_4_title,
          null,
          Translations.of(context).onboarding_page_4_description,
          null,
        ),
        OnboardingItem(
          Translations.of(context).onboarding_page_5_title,
          null,
          Translations.of(context).onboarding_page_5_description,
          null,
        ),
      ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: ChangeNotifierProvider<OnboardingViewModel>(
          create: createViewModel,
          child: Consumer<OnboardingViewModel>(builder: (context, viewModel, _) {
            return Column(
              children: [
                Visibility(
                  visible: showSkipButton,
                  child: _buildTopBar(context, viewModel),
                ),
                Expanded(child: _buildContent(context, viewModel)),
                _buildPagerIndicator(viewModel),
              ],
            );
          }),
        ),
      ),
    );
  }

  @override
  OnboardingViewModel createViewModel(BuildContext context) {
    return OnboardingViewModel(
      context: context,
      settingsRepository: ServiceLocator().get<SettingsRepository>(),
    );
  }

  Widget _buildTopBar(BuildContext context, OnboardingViewModel viewModel) {
    return Align(
      alignment: AlignmentDirectional.centerEnd,
      child: Padding(
        padding: const EdgeInsets.only(left: 8, right: 8, top: 8),
        child: TextButton(
          style: TextButton.styleFrom(
            textStyle: BamTextStyles.buttonTop,
          ),
          onPressed: viewModel.onCompleteAction,
          child: Text(viewModel.isLastPage
              ? Translations.of(context).onboarding_finish_button
              : Translations.of(context).onboarding_skip_button),
        ),
      ),
    );
  }

  Widget _buildBackgroundImage(int index, double height) {
    return OverflowBox(
      maxHeight: 800,
      child: SizedBox(
        height: height,
        child: SvgPicture.asset(
          AssetPaths.onboardingBackgroundShape(index),
          color: BamColorPalette.bamBlack10,
          fit: BoxFit.fitHeight,
        ),
      ),
    );
  }

  Widget _buildForegroundImage(int index, double padding) {
    return Padding(
      padding: EdgeInsets.all(padding),
      child: Image.asset(
        AssetPaths.onboardingFrontImage(index),
        fit: BoxFit.contain,
      ),
    );
  }

  Widget _buildContent(BuildContext context, OnboardingViewModel viewModel) {
    final screenHeight = MediaQuery.of(context).size.height;
    final totalImageHeight = OnboardingContent.imageHeight(context) * 0.90;
    final foregroundImageHeight = screenHeight * 0.45;

    return ResponsiveLayoutBuilder(
      builder: (context, size) {
        final backgroundAlignment = size.size == LayoutSize.tablet ? Alignment(0, -0.6) : Alignment.topCenter;

        return Stack(
          children: [
            Align(
              alignment: backgroundAlignment,
              child: SizedBox(
                height: totalImageHeight,
                child: MultiCrossFadeAnimation(
                  visibleWidgetIndex: viewModel.currentPageIndex,
                  children: [
                    _buildBackgroundImage(1, totalImageHeight),
                    _buildBackgroundImage(2, totalImageHeight * 1.4),
                    _buildBackgroundImage(3, totalImageHeight * 1.1),
                    _buildBackgroundImage(4, totalImageHeight * 1.1),
                    _buildBackgroundImage(5, totalImageHeight),
                  ],
                ),
              ),
            ),
            Align(
              alignment: backgroundAlignment,
              child: SizedBox(
                height: foregroundImageHeight,
                child: MultiCrossFadeAnimation(
                  visibleWidgetIndex: viewModel.currentPageIndex,
                  children: [
                    _buildForegroundImage(1, 32),
                    _buildForegroundImage(2, 0),
                    _buildForegroundImage(3, 64),
                    _buildForegroundImage(4, 48),
                    _buildForegroundImage(5, 48),
                  ],
                ),
              ),
            ),
            PageView.builder(
              onPageChanged: viewModel.onPageChangeAction,
              pageSnapping: true,
              itemCount: viewModel.pageCount,
              itemBuilder: _buildPageContent,
            ),
          ],
        );
      },
    );
  }

  Widget _buildPageContent(BuildContext context, int index) {
    return OnboardingContent(_onBoardingContent(context)[index]);
  }

  Widget _buildPagerIndicator(OnboardingViewModel viewModel) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 16),
      child: DotsIndicator(
        dotsCount: viewModel.pageCount,
        position: viewModel.currentPageIndex.toDouble(),
      ),
    );
  }
}
