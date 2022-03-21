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
import 'package:energielabel_app/data/favorite_repository.dart';
import 'package:energielabel_app/data/label_guide_repository.dart';
import 'package:energielabel_app/service_locator.dart';
import 'package:energielabel_app/ui/favorites/pages/favorite_type.dart';
import 'package:energielabel_app/ui/favorites/pages/favorites_edit_view_model.dart';
import 'package:energielabel_app/ui/misc/page_scaffold.dart';
import 'package:energielabel_app/ui/misc/pages/base_page.dart';
import 'package:energielabel_app/ui/misc/pages/base_view_model.dart';
import 'package:energielabel_app/ui/misc/theme/bam_colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/translations.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:provider/provider.dart';

class FavoritesEditArguments {
  FavoritesEditArguments({required this.favoriteType, this.categoryId});

  final FavoriteType favoriteType;
  final int? categoryId;
}

class FavoritesEditPage extends StatefulPage {
  const FavoritesEditPage({Key? key, required this.favoriteEditArguments}) : super(key: key);

  final FavoritesEditArguments favoriteEditArguments;

  @override
  PageState<StatefulPage, BaseViewModel> createPageState() => _FavoritesEditPageState();
}

class _FavoritesEditPageState extends PageState<FavoritesEditPage, FavoritesEditViewModel> {
  FavoritesEditViewModel? _viewModel;

  @override
  void initState() {
    _viewModel = createViewModel(context);
    scheduleMicrotask(_viewModel!.onViewStarted);
    super.initState();
  }

  @override
  void dispose() {
    _viewModel!.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<FavoritesEditViewModel>.value(
      value: _viewModel!,
      child: Consumer<FavoritesEditViewModel>(
        builder: (context, viewModel, _) {
          return PageScaffold(
            title: _determinePageTitle(context),
            body: _buildList(viewModel),
          );
        },
      ),
    );
  }

  String _determinePageTitle(BuildContext context) {
    switch (widget.favoriteEditArguments.favoriteType) {
      case FavoriteType.products:
        return Translations.of(context)!.edit_favorite_products_page_title;
      case FavoriteType.checklists:
        return Translations.of(context)!.edit_favorite_checklists_page_title;
      case FavoriteType.tips:
        return Translations.of(context)!.edit_favorite_tips_page_title;
      default:
        throw ArgumentError.value(widget.favoriteEditArguments.favoriteType, null, 'Unexpected favorite type.');
    }
  }

  Widget _buildList(FavoritesEditViewModel viewModel) {
    if (viewModel.favoriteListItems.isEmpty) {
      return Center(child: Text(Translations.of(context)!.edit_favorite_empty_state));
    }

    return Container(
      color: Theme.of(context).colorScheme.surface,
      child: ReorderableListView(
        onReorder: viewModel.onFavoriteReordered,
        children: [
          for (final favoriteItem in viewModel.favoriteListItems)
            Column(
              mainAxisSize: MainAxisSize.min,
              key: ValueKey(favoriteItem.favorite),
              children: [
                ListTile(
                  leading: TextButton(
                    onPressed: () => viewModel.onDeleteFavoritesAction(favoriteItem),
                    child: SvgPicture.asset(AssetPaths.favoriteDeleteIcon),
                  ),
                  title: Text(
                    favoriteItem.title,
                    style: Theme.of(context).textTheme.bodyText2!.copyWith(color: BamColorPalette.bamBlue3),
                  ),
                  trailing: Padding(
                    padding: const EdgeInsets.only(left: 8, right: 20),
                    child: SvgPicture.asset(AssetPaths.favoriteSortIcon),
                  ),
                  contentPadding: const EdgeInsets.symmetric(vertical: 4),
                ),
                const Divider(color: BamColorPalette.bamBlack30, indent: 60, height: 2),
              ],
            )
        ],
      ),
    );
  }

  @override
  FavoritesEditViewModel createViewModel(BuildContext context) {
    return FavoritesEditViewModel(
      favoriteType: widget.favoriteEditArguments.favoriteType,
      productCategory: widget.favoriteEditArguments.categoryId,
      favoriteRepository: ServiceLocator().get<FavoriteRepository>()!,
      labelGuideRepository: ServiceLocator().get<LabelGuideRepository>()!,
      deletionConfirmationCallback: () => _showDeletionConfirmationSnackBar(context),
    );
  }

  // Shows a snackBar as additional visual confirmation that the favorites have been deleted.
  // While the snackBar is visible the user has the option to 'undo' the deletion. If not invoked,
  // the view model is told to permanently delete the favorites.
  Future<void> _showDeletionConfirmationSnackBar(BuildContext context) async {
    final snackBar = SnackBar(
      content: Text(Translations.of(context)!.edit_favorite_deletion_confirmation),
      action: SnackBarAction(
        label: Translations.of(context)!.edit_favorite_deletion_undo_action,
        onPressed: () => _viewModel!.onUndoDeletionAction(),
      ),
      duration: const Duration(seconds: 2),
    );

    final closeReason = await ScaffoldMessenger.maybeOf(context)!.showSnackBar(snackBar).closed;
    if (closeReason != SnackBarClosedReason.action) {
      unawaited(_viewModel!.onUndoDeletionOptionIgnored());
    }
  }
}
