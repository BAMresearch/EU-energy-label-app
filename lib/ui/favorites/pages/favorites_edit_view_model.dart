/* * Copyright 2020 Bundesanstalt für Materialforschung und -prüfung (BAM) *
* Licensed under the EUPL, Version 1.2 or – as soon they will be approved by the European Commission - subsequent versions of the EUPL (the "Licence");
* You may not use this work except in compliance with theLicence.
* You may obtain a copy of the Licence at:
* * https://joinup.ec.europa.eu/software/page/eupl *
* Unless required by applicable law or agreed to in writing, software distributed under the Licence is distributed on an "AS IS" basis,
* WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
* See the Licence for the specific language governing permissions and limitations under the Licence.*/

import 'dart:async';
import 'dart:developer';

import 'package:energielabel_app/data/favorite_repository.dart';
import 'package:energielabel_app/data/label_guide_repository.dart';
import 'package:energielabel_app/model/favorite.dart';
import 'package:energielabel_app/ui/favorites/favorite_list_item.dart';
import 'package:energielabel_app/ui/favorites/pages/favorite_type.dart';
import 'package:energielabel_app/ui/misc/pages/base_view_model.dart';
import 'package:flutter/foundation.dart';

class FavoritesEditViewModel extends BaseViewModel {
  FavoritesEditViewModel({
    required FavoriteType favoriteType,
    required int? productCategory,
    required FavoriteRepository favoriteRepository,
    required LabelGuideRepository labelGuideRepository,
    required VoidCallback deletionConfirmationCallback,
  })  : assert((favoriteType == FavoriteType.products && productCategory != null) ||
            (favoriteType != FavoriteType.products && productCategory == null)),
        _favoriteType = favoriteType,
        _productCategory = productCategory,
        _favoriteRepository = favoriteRepository,
        _labelGuideRepository = labelGuideRepository,
        _deletionConfirmationCallback = deletionConfirmationCallback;

  final FavoriteType _favoriteType;
  final int? _productCategory;
  final FavoriteRepository _favoriteRepository;
  final LabelGuideRepository _labelGuideRepository;
  final VoidCallback _deletionConfirmationCallback;
  final List<FavoriteListSectionEntry> _favoriteListSectionEntries = [];
  final List<FavoriteListSectionEntry> _restorableItems = [];

  List<FavoriteListSectionEntry> get favoriteListItems => List.unmodifiable(_favoriteListSectionEntries);

  @override
  void onViewStarted() {
    _observeFavorites();
  }

  void onDeleteFavoritesAction(FavoriteListSectionEntry listItem) {
    // Keep a backup in case the user wants to restore the items.
    _restorableItems.addAll(List.of(_favoriteListSectionEntries));

    // Remove them from the UI state.
    _favoriteListSectionEntries.removeWhere((favoriteListItem) => favoriteListItem == listItem);
    notifyListeners();

    // Show a snackBar with undo action.
    _deletionConfirmationCallback.call();
  }

  Future<void> onUndoDeletionOptionIgnored() async {
    try {
      await _saveEditedFavorites();
      _restorableItems.clear();
    } catch (error, stacktrace) {
      // TODO Should the user be informed and the items be visible in the UI again?
      log('Failed to permanently delete favorites.', error: error, stackTrace: stacktrace);
    }
  }

  void onUndoDeletionAction() {
    // Restore the favorites
    _favoriteListSectionEntries.clear();
    _favoriteListSectionEntries.addAll(List.from(_restorableItems));
    _restorableItems.clear();
    notifyListeners();
  }

  void onFavoriteReordered(previousIndex, newIndex) {
    final reorderedFavorite = _favoriteListSectionEntries[previousIndex];
    _favoriteListSectionEntries.remove(reorderedFavorite);
    if (newIndex >= _favoriteListSectionEntries.length) {
      _favoriteListSectionEntries.add(reorderedFavorite);
    } else {
      _favoriteListSectionEntries.insert(newIndex, reorderedFavorite);
    }
    unawaited(_saveEditedFavorites());
  }

  Future<String?> _resolveTitleForCategory(int? categoryId) async {
    final category = await _labelGuideRepository.getCategory(categoryId);
    if (category != null) {
      return category.productType;
    } else {
      log('Category lookup failed with ID: $categoryId');
      return '';
    }
  }

  void _observeFavorites() {
    late Stream<List<Favorite>?> favoritesStream;
    late FutureOr<String?> Function(Favorite) titleResolver;

    switch (_favoriteType) {
      case FavoriteType.products:
        favoritesStream = _favoriteRepository.favoriteProductsUpdates!
            .map((productsForCategories) => productsForCategories[_productCategory]);
        titleResolver = (favorite) {
          final productFavorite = favorite as ProductFavorite;
          // A ProductFavorite might be created without an attached Product object (QR scanner input).
          // In that case, we fall back to the ProductFavorite's title.
          return productFavorite.product?.title ?? productFavorite.title;
        };
        break;
      case FavoriteType.checklists:
        favoritesStream = _favoriteRepository.favoriteChecklistsUpdates;
        titleResolver = (favorite) => _resolveTitleForCategory((favorite as ChecklistFavorite).categoryId);
        break;
      case FavoriteType.tips:
        favoritesStream = _favoriteRepository.favoriteCategoryTipsUpdates;
        titleResolver = (favorite) => _resolveTitleForCategory((favorite as CategoryTipsFavorite).categoryId);
        break;
    }

    subscriptions.add(favoritesStream.listen((favorites) async {
      _favoriteListSectionEntries.clear();

      for (final favorite in favorites!) {
        _favoriteListSectionEntries.add(
          FavoriteListSectionEntry(
            title: (await (titleResolver(favorite)) ?? ''),
            favoriteType: _favoriteType,
            favorite: favorite,
          ),
        );
      }
      notifyListeners();
    })).onError((error, stacktrace) {
      // TODO Show error to the user.
      log('Failed to observe the favorites.', error: error, stackTrace: stacktrace);
    });
  }

  Future<void> _saveEditedFavorites() async {
    try {
      switch (_favoriteType) {
        case FavoriteType.products:
          final favorites = _favoriteListSectionEntries
              .map<ProductFavorite>((listItem) => listItem.favorite as ProductFavorite)
              .toList();
          _favoriteRepository.latestProductList![_productCategory] = favorites;
          await _favoriteRepository.updateProductFavorites(_favoriteRepository.latestProductList!);
          break;
        case FavoriteType.checklists:
          final favorites = _favoriteListSectionEntries
              .map<ChecklistFavorite>((listItem) => listItem.favorite as ChecklistFavorite)
              .toList();
          await _favoriteRepository.updateChecklistFavorites(favorites);
          break;
        case FavoriteType.tips:
          final favorites = _favoriteListSectionEntries
              .map<CategoryTipsFavorite>((listItem) => listItem.favorite as CategoryTipsFavorite)
              .toList();
          await _favoriteRepository.updateCategoryTipsFavorites(favorites);
          break;
      }
    } catch (e, stacktrace) {
      // TODO Should we show an error message? Should we restore the previous list state?
      log('Failed to save the updated favorites.', error: e, stackTrace: stacktrace);
    }
  }
}
