/* * Copyright 2020 Bundesanstalt für Materialforschung und -prüfung (BAM) *
* Licensed under the EUPL, Version 1.2 or – as soon they will be approved by the European Commission - subsequent versions of the EUPL (the "Licence");
* You may not use this work except in compliance with theLicence.
* You may obtain a copy of the Licence at:
* * https://joinup.ec.europa.eu/software/page/eupl *
* Unless required by applicable law or agreed to in writing, software distributed under the Licence is distributed on an "AS IS" basis,
* WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
* See the Licence for the specific language governing permissions and limitations under the Licence.*/

import 'package:energielabel_app/data/asset_paths.dart';
import 'package:energielabel_app/data/favorite_repository.dart';
import 'package:energielabel_app/data/label_guide_repository.dart';
import 'package:energielabel_app/model/know_how/label_guide/label_category.dart';
import 'package:energielabel_app/service_locator.dart';
import 'package:energielabel_app/ui/know_how/components/category_header.dart';
import 'package:energielabel_app/ui/know_how/components/label_guide/category_tip_tile.dart';
import 'package:energielabel_app/ui/know_how/favorite_action_listener.dart';
import 'package:energielabel_app/ui/know_how/pages/label_guide/category_tips_view_model.dart';
import 'package:energielabel_app/ui/misc/page_scaffold.dart';
import 'package:energielabel_app/ui/misc/pages/base_page.dart';
import 'package:energielabel_app/ui/misc/theme/bam_colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/translations.dart';
import 'package:provider/provider.dart';

class CategoryTipsPageArguments {
  CategoryTipsPageArguments({required this.labelCategory});

  final LabelCategory labelCategory;
}

/// Page showing tips for a specific label guide category (refrigerators, etc.).
class CategoryTipsPage extends StatelessPage<CategoryTipsViewModel> {
  CategoryTipsPage({Key? key, required CategoryTipsPageArguments argument})
      : _labelCategory = argument.labelCategory,
        super(key: key);

  final LabelCategory _labelCategory;

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<CategoryTipsViewModel>(
      create: (context) => createViewModel(context)..onViewStarted(),
      child: Consumer<CategoryTipsViewModel>(builder: (context, viewModel, _) {
        return PageScaffold(
          title: Translations.of(context)!.tips_page_title,
          actions: [
            IconButton(
              icon: Icon(
                viewModel.isFavorite ? Icons.star : Icons.star_border,
                color: BamColorPalette.bamBlack,
                semanticLabel: viewModel.isFavorite
                    ? Translations.of(context)!.label_tips_remove_favorite_icon_semantics
                    : Translations.of(context)!.label_tips_add_favorite_icon_semantics,
              ),
              onPressed: viewModel.onToggleFavoriteAction,
            )
          ],
          body: _buildBody(context, viewModel),
        );
      }),
    );
  }

  @override
  CategoryTipsViewModel createViewModel(BuildContext context) {
    return CategoryTipsViewModel(
      labelGuideRepository: ServiceLocator().get<LabelGuideRepository>()!,
      context: context,
      labelCategory: _labelCategory,
      favoriteRepository: ServiceLocator().get<FavoriteRepository>()!,
      favoriteActionListener: _FavoriteActionListener(context: context),
    );
  }

  Widget _buildBody(BuildContext context, CategoryTipsViewModel viewModel) {
    return Scrollbar(
      child: SingleChildScrollView(
        physics: const ClampingScrollPhysics(),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildTipHeader(context),
            ..._labelCategory.tipData!.labelTips!
                .map((tip) => CategoryTipTile(
                      onLinkTap: viewModel.onLinkTap,
                      tipNumber: _labelCategory.tipData!.labelTips!.indexOf(tip) + 1,
                      labelTip: tip,
                    ))
                .toList()
          ],
        ),
      ),
    );
  }

  Widget _buildTipHeader(BuildContext context) {
    return CategoryHeader(
      title: _labelCategory.tipData!.title!,
      backgroundColorHex: _labelCategory.backgroundColorHex!,
      titleColorHex: _labelCategory.textColorHex!,
      image: AssetPaths.labelGuideCategoryImage(_labelCategory.graphicPath),
    );
  }
}

class _FavoriteActionListener extends FavoriteActionListener {
  _FavoriteActionListener({required this.context});

  final BuildContext context;

  @override
  void onAddFavoriteSuccess() {
    ScaffoldMessenger.maybeOf(context)!.showSnackBar(
      SnackBar(content: Text(Translations.of(context)!.label_tips_add_favorite_success)),
    );
  }

  @override
  void onAddFavoriteFailure() {
    ScaffoldMessenger.maybeOf(context)!.showSnackBar(
      SnackBar(content: Text(Translations.of(context)!.label_tips_add_favorite_failure)),
    );
  }

  @override
  void onRemoveFavoriteSuccess() {
    ScaffoldMessenger.maybeOf(context)!.showSnackBar(
      SnackBar(content: Text(Translations.of(context)!.label_tips_remove_favorite_success)),
    );
  }

  @override
  void onRemoveFavoriteFailure() {
    ScaffoldMessenger.maybeOf(context)!.showSnackBar(
      SnackBar(content: Text(Translations.of(context)!.label_tips_remove_favorite_failure)),
    );
  }
}
