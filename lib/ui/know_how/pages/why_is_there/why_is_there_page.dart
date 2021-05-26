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
import 'package:energielabel_app/data/why_is_there_repository.dart';
import 'package:energielabel_app/model/know_how/why_is_there/why_is_there_entry.dart';
import 'package:energielabel_app/service_locator.dart';
import 'package:energielabel_app/ui/know_how/pages/why_is_there/why_is_there_view_model.dart';
import 'package:energielabel_app/ui/misc/components/multi_cross_fade_animation.dart';
import 'package:energielabel_app/ui/misc/html_utils.dart';
import 'package:energielabel_app/ui/misc/page_scaffold.dart';
import 'package:energielabel_app/ui/misc/pages/base_page.dart';
import 'package:energielabel_app/ui/misc/theme/bam_colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/translations.dart';
import 'package:flutter_html/style.dart';
import 'package:provider/provider.dart';

class WhyIsTherePage extends StatelessPage<WhyIsThereViewModel> {
  WhyIsTherePage({int initialIndex = 0}) : _initialIndex = initialIndex;

  final PageController _pageController = PageController();
  final int _initialIndex;

  @override
  Widget build(BuildContext context) {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (_pageController.hasClients) {
        _pageController.jumpToPage(_initialIndex);
      }
    });

    return ChangeNotifierProvider<WhyIsThereViewModel>(
      create: (context) => createViewModel(context)..onViewStarted(),
      child: Consumer<WhyIsThereViewModel>(
        builder: (context, viewModel, _) {
          return PageScaffold(
            title: Translations.of(context).know_how_item_why_is_there,
            body: _buildContent(context, viewModel),
          );
        },
      ),
    );
  }

  @override
  WhyIsThereViewModel createViewModel(BuildContext context) {
    return WhyIsThereViewModel(
      initialIndex: _initialIndex,
      whyIsThereRepository: ServiceLocator().get<WhyIsThereRepository>(),
    );
  }

  Widget _buildContent(BuildContext context, WhyIsThereViewModel viewModel) {
    return Stack(
      children: [
        MultiCrossFadeAnimation(
          visibleWidgetIndex: viewModel.currentPageIndex,
          children: [
            Image.asset(
              AssetPaths.whyIsThereBackgroundImage(1),
              color: BamColorPalette.bamBlack15,
              fit: BoxFit.fitWidth,
            ),
            Image.asset(
              AssetPaths.whyIsThereBackgroundImage(2),
              color: BamColorPalette.bamBlack15,
              fit: BoxFit.fitWidth,
            ),
            Image.asset(
              AssetPaths.whyIsThereBackgroundImage(3),
              color: BamColorPalette.bamBlack15,
              fit: BoxFit.fitWidth,
            ),
            Image.asset(
              AssetPaths.whyIsThereBackgroundImage(4),
              color: BamColorPalette.bamBlack15,
              height: 500,
              fit: BoxFit.fitWidth,
            ),
            Image.asset(
              AssetPaths.whyIsThereBackgroundImage(5),
              color: BamColorPalette.bamBlack15,
              fit: BoxFit.fitWidth,
            ),
          ],
        ),

        Padding(
          padding: const EdgeInsets.symmetric(vertical: 24),
          child: MultiCrossFadeAnimation(
            visibleWidgetIndex: viewModel.currentPageIndex,
            children: List.generate(viewModel.pageCount, (index) => _buildEnergyLabelImages(context, index, viewModel)),
          ),
        ),

        Padding(
          padding: const EdgeInsets.only(bottom: 40),
          child: PageView.builder(
            controller: _pageController,
            onPageChanged: viewModel.onPageChangeAction,
            itemCount: viewModel.pageCount,
            itemBuilder: (context, index) => _buildPageViewContent(context, index, viewModel),
          ),
        ),
        _buildPagerIndicator(viewModel),
      ],
    );
  }

  Widget _buildEnergyLabelImages(BuildContext context, int index, WhyIsThereViewModel viewModel) {
    final whyIsThereEntry = viewModel.entry(index);
    final screenHeight = MediaQuery.of(context).size.height;

    if (whyIsThereEntry.imageUri == null) {
      return Container();
    }

    if (whyIsThereEntry.text == null) {
      return Align(
        alignment: Alignment.center,
        child: Image.asset(AssetPaths.whyIsThereFrontImage(whyIsThereEntry.imageUri), height: screenHeight / 1.8),
      );
    }

    return Align(
      alignment: Alignment.topCenter,
      child: Image.asset(AssetPaths.whyIsThereFrontImage(whyIsThereEntry.imageUri), height: screenHeight / 2.6),
    );
  }

  Widget _buildPageViewContent(BuildContext context, int index, WhyIsThereViewModel viewModel) {
    final whyIsThereEntry = viewModel.entry(index);
    final screenHeight = MediaQuery.of(context).size.height;

    final scrollController = ScrollController();

    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 8, 20, 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (whyIsThereEntry.imageUri != null)
            Padding(
              padding: EdgeInsets.only(bottom: 48 + screenHeight * 0.025),
              child: SizedBox(height: screenHeight / 3),
            ),

          Expanded(
            child: Scrollbar(
              controller: scrollController,
              isAlwaysShown: true,
              child: SingleChildScrollView(
                controller: scrollController,
                child: Column(
                  children: [
                    if (whyIsThereEntry.title != null) _buildTitle(context, index, whyIsThereEntry),

                    if (whyIsThereEntry.text != null)
                      Semantics(
                        label: whyIsThereEntry.textSemantic,
                        excludeSemantics: true,
                        child: HtmlUtils.stringToHtml(context, whyIsThereEntry.text),
                      ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTitle(BuildContext context, int index, WhyIsThereEntry whyIsThereEntry) {
    return HtmlUtils.stringToHtml(
      context,
      whyIsThereEntry.title,
      customStyle: {
        'span': Style.fromTextStyle(Theme.of(context).textTheme.headline1.copyWith(
              fontWeight: FontWeight.w500,
              color: BamColorPalette.bamBlue3,
            ))
      },
    );
  }

  Widget _buildPagerIndicator(WhyIsThereViewModel viewModel) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 24),
      child: Align(
        alignment: Alignment.bottomCenter,
        child: viewModel.pageCount == 0
            ? SizedBox.shrink()
            : DotsIndicator(
                dotsCount: viewModel.pageCount,
                position: viewModel.currentPageIndex.toDouble(),
              ),
      ),
    );
  }
}
