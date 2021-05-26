/* * Copyright 2020 Bundesanstalt für Materialforschung und -prüfung (BAM) *
* Licensed under the EUPL, Version 1.2 or – as soon they will be approved by the European Commission - subsequent versions of the EUPL (the "Licence");
* You may not use this work except in compliance with theLicence.
* You may obtain a copy of the Licence at:
* * https://joinup.ec.europa.eu/software/page/eupl *
* Unless required by applicable law or agreed to in writing, software distributed under the Licence is distributed on an "AS IS" basis,
* WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
* See the Licence for the specific language governing permissions and limitations under the Licence.*/

import 'dart:convert';

import 'package:collection/collection.dart';
import 'package:energielabel_app/model/favorite.dart';
import 'package:shared_preferences/shared_preferences.dart';

class FavoriteDao {
  FavoriteDao(SharedPreferences sharedPreferences)
      : assert(sharedPreferences != null),
        _sharedPreferences = sharedPreferences;

  static const String _favoriteProductsKey = 'favorite_products';
  static const String _favoriteChecklistsKey = 'favorite_checklists';
  static const String _favoriteCategoryTipsKey = 'favorite_category_tips';

  final SharedPreferences _sharedPreferences;

  List<ProductFavorite> _getProductFavoritesAsList() {
    return _getFavorites(_favoriteProductsKey, (favoriteJson) => ProductFavorite.fromJson(favoriteJson));
  }

  Map<int, List<ProductFavorite>> getProductFavorites({List<ProductFavorite> favorites}) {
    return groupBy<ProductFavorite, int>(favorites ?? _getProductFavoritesAsList(), (product) => product.categoryId);
  }

  Future<Map<int, List<ProductFavorite>>> addProductFavorite(ProductFavorite favorite, int categoryId) async {
    final List<ProductFavorite> favorites = _getProductFavoritesAsList();
    favorites.add(favorite);
    await _saveFavorites(_favoriteProductsKey, favorites);
    return getProductFavorites(favorites: favorites);
  }

  Future<Map<int, List<ProductFavorite>>> removeProductFavorite(ProductFavorite favorite, int categoryId) async {
    final List<ProductFavorite> favorites = _getProductFavoritesAsList();
    favorites.remove(favorite);
    await _saveFavorites(_favoriteProductsKey, favorites);
    return getProductFavorites(favorites: favorites);
  }

  Future<void> updateProductFavorites(Map<int, List<ProductFavorite>> favorites) async {
    await _saveFavorites(_favoriteProductsKey, favorites.values.expand((element) => element).toList());
  }

  List<ChecklistFavorite> getChecklistFavorites() {
    return _getFavorites(_favoriteChecklistsKey, (favoriteJson) => ChecklistFavorite.fromJson(favoriteJson));
  }

  Future<List<ChecklistFavorite>> addChecklistFavorite(ChecklistFavorite favorite) async {
    final favorites = getChecklistFavorites();
    favorites.add(favorite);
    await _saveFavorites(_favoriteChecklistsKey, favorites);
    return favorites;
  }

  Future<List<ChecklistFavorite>> removeChecklistFavorite(ChecklistFavorite favorite) async {
    final favorites = getChecklistFavorites();
    favorites.remove(favorite);
    await _saveFavorites(_favoriteChecklistsKey, favorites);
    return favorites;
  }

  Future<void> updateChecklistFavorites(List<ChecklistFavorite> favorites) async {
    await _saveFavorites(_favoriteChecklistsKey, favorites);
  }

  List<CategoryTipsFavorite> getCategoryTipsFavorites() {
    return _getFavorites(
      _favoriteCategoryTipsKey,
      (favoriteJson) => CategoryTipsFavorite.fromJson(favoriteJson),
    );
  }

  Future<List<CategoryTipsFavorite>> addTipsFavorite(CategoryTipsFavorite favorite) async {
    final favorites = getCategoryTipsFavorites();
    favorites.add(favorite);
    await _saveFavorites(_favoriteCategoryTipsKey, favorites);
    return favorites;
  }

  Future<void> updateTipsFavorites(List<CategoryTipsFavorite> favorites) async {
    await _saveFavorites(_favoriteCategoryTipsKey, favorites);
  }

  Future<List<CategoryTipsFavorite>> removeCategoryTipsFavorite(CategoryTipsFavorite favorite) async {
    final favorites = getCategoryTipsFavorites();
    favorites.remove(favorite);
    await _saveFavorites(_favoriteCategoryTipsKey, favorites);
    return favorites;
  }

  List<T> _getFavorites<T extends Favorite>(String key, T Function(Map<String, dynamic> favoriteJson) fromJson) {
    final jsonFavorites = _sharedPreferences.getStringList(key);

    if (jsonFavorites != null) {
      return jsonFavorites.map<T>((jsonFavorite) => fromJson(jsonDecode(jsonFavorite))).toList();
    }
    return <T>[];
  }

  Future<void> _saveFavorites<T extends Favorite>(String key, List<T> favorites) async {
    final jsonFavorites = favorites.map((favorite) => jsonEncode(favorite)).toList();
    await _sharedPreferences.setStringList(key, jsonFavorites);
  }
}
