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
import 'package:energielabel_app/service_locator.dart';
import 'package:energielabel_app/ui/favorites/components/favorite_section_item.dart';
import 'package:energielabel_app/ui/favorites/components/favorites_tab_bar.dart';
import 'package:energielabel_app/ui/favorites/favorite_list_item.dart';
import 'package:energielabel_app/ui/favorites/pages/favorites_view_model.dart';
import 'package:energielabel_app/ui/misc/page_scaffold.dart';
import 'package:energielabel_app/ui/misc/pages/base_page.dart';
import 'package:energielabel_app/ui/misc/pages/view_state.dart';
import 'package:energielabel_app/ui/misc/theme/bam_colors.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/translations.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:provider/provider.dart';

class FavoritesPage extends StatelessPage<FavoritesViewModel> {
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<FavoritesViewModel>(
      create: (context) => createViewModel(context)..onViewStarted(),
      child: Consumer<FavoritesViewModel>(
        builder: (context, viewModel, _) {
          return PageScaffold(
            hasElevation: false,
            actions: [
              Semantics(
                label: Translations.of(context).favorites_page_export_dialog_title,
                excludeSemantics: true,
                button: true,
                onTap: viewModel.exportPdf,
                child: IconButton(
                  icon: SvgPicture.asset(
                    AssetPaths.shareIcon,
                    color: viewModel.isFavoritesEmpty ? BamColorPalette.bamBlack45Optimized : BamColorPalette.bamBlack,
                  ),
                  onPressed: viewModel.isFavoritesEmpty ? null : viewModel.exportPdf,
                ),
              ),
            ],
            title: Translations.of(context).favorites_page_title,
            body: Builder(
              builder: (context) {
                switch (viewModel.viewState) {
                  case ViewState.initializing:
                    return _buildProgressState();
                  case ViewState.initialized:
                    return _buildInitializedState(context, viewModel);
                  default:
                    return SizedBox.shrink();
                }
              },
            ),
          );
        },
      ),
    );
  }

  @override
  FavoritesViewModel createViewModel(BuildContext context) {
    return FavoritesViewModel(
      context: context,
      favoriteRepository: ServiceLocator().get<FavoriteRepository>(),
      labelGuideRepository: ServiceLocator().get<LabelGuideRepository>(),
    );
  }

  Widget _buildProgressState() {
    return Center(child: CircularProgressIndicator());
  }

  Widget _buildInitializedState(BuildContext context, FavoritesViewModel viewModel) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        _buildTabBar(context, viewModel),
        _buildFavoriteList(context, viewModel),
      ],
    );
  }

  Widget _buildTabBar(BuildContext context, FavoritesViewModel viewModel) {
    return FavoritesTabBar<FavoritesTab>(
      children: {
        FavoritesTab.products: Translations.of(context).favorites_tab_products,
        FavoritesTab.knowHow: Translations.of(context).favorites_tab_know_how,
      },
      groupValue: viewModel.selectedFavoritesTab,
      onValueChanged: viewModel.onTabSelected,
    );
  }

  Widget _buildFavoriteList(BuildContext context, FavoritesViewModel viewModel) {
    List<FavoriteListSection> favoritesList;
    switch (viewModel.selectedFavoritesTab) {
      case FavoritesTab.products:
        favoritesList = viewModel.favoriteProductListSections;
        break;
      case FavoritesTab.knowHow:
        favoritesList = viewModel.favoriteKnowHowListSections;
        break;
      default:
        throw ArgumentError.value(viewModel.selectedFavoritesTab);
    }

    if (favoritesList.isNotEmpty) {
      return Expanded(
        child: ListView.builder(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          itemCount: favoritesList.length,
          itemBuilder: (context, index) => FavoriteSectionItem(
            favoriteListSection: favoritesList[index],
            onEntryPressed: viewModel.onFavoriteSelected,
            onEditPressed: viewModel.onEditFavoriteSection,
          ),
        ),
      );
    }

    return _buildEmptyState(context, viewModel);
  }

  Widget _buildEmptyState(BuildContext context, FavoritesViewModel viewModel) {
    return Expanded(
      child: Center(
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Text(
            Translations.of(context).favorites_no_favorite,
            textAlign: TextAlign.center,
            style: Theme.of(context).textTheme.headline1.copyWith(
                  color: BamColorPalette.bamBlue3,
                ),
          ),
        ),
      ),
    );
  }
}
