/* * Copyright 2020 Bundesanstalt für Materialforschung und -prüfung (BAM) *
* Licensed under the EUPL, Version 1.2 or – as soon they will be approved by the European Commission - subsequent versions of the EUPL (the "Licence");
* You may not use this work except in compliance with theLicence.
* You may obtain a copy of the Licence at:
* * https://joinup.ec.europa.eu/software/page/eupl *
* Unless required by applicable law or agreed to in writing, software distributed under the Licence is distributed on an "AS IS" basis,
* WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
* See the Licence for the specific language governing permissions and limitations under the Licence.*/

import 'dart:async';

import 'package:energielabel_app/data/asset_paths.dart';
import 'package:energielabel_app/ui/home/components/home_drawer.dart';
import 'package:energielabel_app/ui/home/pages/home_view_model.dart';
import 'package:energielabel_app/ui/misc/components/item_button.dart';
import 'package:energielabel_app/ui/misc/components/label_guide_card.dart';
import 'package:energielabel_app/ui/misc/page_scaffold.dart';
import 'package:energielabel_app/ui/misc/pages/base_page.dart';
import 'package:energielabel_app/ui/misc/theme/bam_colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/translations.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:provider/provider.dart';

class HomePage extends StatefulPage {
  const HomePage({Key? key}) : super(key: key);

  @override
  _HomePageState createPageState() => _HomePageState();
}

class _HomePageState extends PageState<HomePage, HomeViewModel> {
  HomeViewModel? _viewModel;

  @override
  void initState() {
    _viewModel = createViewModel(context);
    scheduleMicrotask(_viewModel!.onViewStarted);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return PageScaffold(
      hasElevation: false,
      customAppBarContent: _buildBamLogo(context),
      drawerIcon: AssetPaths.drawerIcon,
      drawer: Builder(builder: (_) => const HomeDrawer()),
      body: _buildBody(),
    );
  }

  @override
  void dispose() {
    _viewModel!.dispose();
    super.dispose();
  }

  Widget _buildBamLogo(BuildContext context) {
    return MergeSemantics(
      child: Align(
        alignment: AlignmentDirectional.centerEnd,
        child: SizedBox(
          width: 100,
          height: 40,
          child: Center(
            child: SvgPicture.asset(AssetPaths.logoImage,
                semanticsLabel: Translations.of(context)!.semantic_home_dashboard_logo),
          ),
        ),
      ),
    );
  }

  Widget _buildBody() {
    return ChangeNotifierProvider<HomeViewModel>.value(
      value: _viewModel!,
      child: Consumer<HomeViewModel>(
        builder: (context, viewModel, _) {
          return Scrollbar(
            child: SingleChildScrollView(
              physics: const ClampingScrollPhysics(), //prevents scroll bouncing
              child: Column(
                children: [
                  LabelGuideCard(onPressed: viewModel.onLabelGuideTilePressed),
                  const SizedBox(height: 20),
                  FractionallySizedBox(
                    widthFactor: 336 / 375,
                    child: AspectRatio(
                      aspectRatio: 336 / 145,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          _buildImageCard(
                            Translations.of(context)!.home_dashboard_qr_code_reader,
                            AssetPaths.qrScanImage,
                            backgroundColor: BamColorPalette.bamYellow1,
                            textColor: BamColorPalette.bamBlack,
                            onPressed: viewModel.onScannerTilePressed,
                          ),
                          const Spacer(),
                          _buildImageCard(
                            Translations.of(context)!.home_dashboard_energy_quiz,
                            AssetPaths.quizImage,
                            backgroundColor: BamColorPalette.bamBlue4,
                            textColor: BamColorPalette.bamWhite,
                            onPressed: viewModel.onQuizTilePressed,
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),
                  _buildSmallDashboardItems(context, Translations.of(context)!.home_dashboard_favorites,
                      AssetPaths.menuFavoritesIcon, viewModel.onFavoriteTilePressed),
                  const SizedBox(height: 20),
                  _buildSmallDashboardItems(context, Translations.of(context)!.home_dashboard_first_steps,
                      AssetPaths.menuFirstStepsIcon, viewModel.onFirstStepsTilePressed),
                  const SizedBox(height: 20),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildSmallDashboardItems(BuildContext context, String title, String iconPath, VoidCallback onTap) {
    return Semantics(
      button: true,
      label: title,
      excludeSemantics: true,
      child: FractionallySizedBox(
        widthFactor: 336 / 375,
        child: ItemButton.fromIconAsset(
          label: title,
          iconAssetPath: iconPath,
          onTap: onTap,
        ),
      ),
    );
  }

  Widget _buildImageCard(String title, String image,
      {Color? backgroundColor, Color? textColor, VoidCallback? onPressed}) {
    return Semantics(
      button: true,
      label: title,
      excludeSemantics: true,
      child: AspectRatio(
        aspectRatio: 158 / 145,
        child: GestureDetector(
          onTap: onPressed,
          child: Container(
            alignment: Alignment.topLeft,
            decoration: BoxDecoration(borderRadius: BorderRadius.circular(8), color: backgroundColor),
            child: Stack(
              children: [
                Align(
                  alignment: Alignment.bottomRight,
                  child: Padding(
                    padding: const EdgeInsets.only(top: 10.0),
                    child: Image.asset(image),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(16),
                  child: Text(
                    title,
                    style: Theme.of(context).textTheme.headline3!.copyWith(color: textColor),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  @override
  HomeViewModel createViewModel(BuildContext context) {
    return HomeViewModel(
      context: context,
    );
  }
}
