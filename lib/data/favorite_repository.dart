/* * Copyright 2020 Bundesanstalt für Materialforschung und -prüfung (BAM) *
* Licensed under the EUPL, Version 1.2 or – as soon they will be approved by the European Commission - subsequent versions of the EUPL (the "Licence");
* You may not use this work except in compliance with theLicence.
* You may obtain a copy of the Licence at:
* * https://joinup.ec.europa.eu/software/page/eupl *
* Unless required by applicable law or agreed to in writing, software distributed under the Licence is distributed on an "AS IS" basis,
* WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
* See the Licence for the specific language governing permissions and limitations under the Licence.*/

import 'package:collection/collection.dart';
import 'package:energielabel_app/data/persistence/favorite_dao.dart';
import 'package:energielabel_app/data/repository_exception.dart';
import 'package:energielabel_app/model/favorite.dart';
import 'package:rxdart/rxdart.dart';

final bool Function(List, List) compareListFunction = const ListEquality().equals;
final bool Function(Map, Map) compareMapFunction = const DeepCollectionEquality().equals;

class FavoriteRepository {
  FavoriteRepository(FavoriteDao favoriteDao) : _favoriteDao = favoriteDao {
    _initFavoriteProductsUpdates();
    _initFavoriteChecklistsUpdates();
    _initFavoriteLabelTipsUpdates();
  }

  final FavoriteDao _favoriteDao;
  BehaviorSubject<Map<int?, List<ProductFavorite>>>? _favoriteProductsSubject;
  late BehaviorSubject<List<ChecklistFavorite>> _favoriteChecklistsSubject;
  late BehaviorSubject<List<CategoryTipsFavorite>> _favoriteCategoryTipsSubject;

  Stream<Map<int?, List<ProductFavorite>>>? get favoriteProductsUpdates => _favoriteProductsSubject;

  Map<int?, List<ProductFavorite>>? get latestProductList => _favoriteProductsSubject!.value;

  Stream<List<ChecklistFavorite>> get favoriteChecklistsUpdates =>
      _favoriteChecklistsSubject.distinct(compareListFunction);

  List<ChecklistFavorite>? get latestChecklistsList => _favoriteChecklistsSubject.value;

  Stream<List<CategoryTipsFavorite>> get favoriteCategoryTipsUpdates =>
      _favoriteCategoryTipsSubject.distinct(compareListFunction);

  List<CategoryTipsFavorite>? get latestCategoryTipsFavoriteList => _favoriteCategoryTipsSubject.value;

  Future<void> addProductFavorite(ProductFavorite favorite) async {
    try {
      final favorites = await _favoriteDao.addProductFavorite(favorite, favorite.categoryId);
      _favoriteProductsSubject!.add(favorites);
    } catch (e) {
      throw RepositoryException('Failed to add product favorite.', e);
    }
  }

  Future<void> removeProductFavorite(ProductFavorite favorite) async {
    try {
      final updatedFavorites = await _favoriteDao.removeProductFavorite(favorite, favorite.categoryId);
      _favoriteProductsSubject!.add(updatedFavorites);
    } catch (e) {
      throw RepositoryException('Failed to remove product favorite.', e);
    }
  }

  Future<void> updateProductFavorites(Map<int?, List<ProductFavorite>> favorites) async {
    try {
      await _favoriteDao.updateProductFavorites(favorites);
      _favoriteProductsSubject!.add(favorites);
    } catch (e) {
      throw RepositoryException('Failed to update product favorites.', e);
    }
  }

  Future<void> addChecklistFavorite(ChecklistFavorite checklistFavorite) async {
    try {
      final updatedFavorites = await _favoriteDao.addChecklistFavorite(checklistFavorite);
      _favoriteChecklistsSubject.add(updatedFavorites);
    } catch (e) {
      throw RepositoryException('Failed to add checklist favorite.', e);
    }
  }

  Future<void> removeChecklistFavorite(ChecklistFavorite favorite) async {
    try {
      final updatedFavorites = await _favoriteDao.removeChecklistFavorite(favorite);
      _favoriteChecklistsSubject.add(updatedFavorites);
    } catch (e) {
      throw RepositoryException('Failed to remove checklist favorite.', e);
    }
  }

  Future<void> updateChecklistFavorites(List<ChecklistFavorite> favorites) async {
    try {
      await _favoriteDao.updateChecklistFavorites(favorites);
      _favoriteChecklistsSubject.add(favorites);
    } catch (e) {
      throw RepositoryException('Failed to update checklist favorites.', e);
    }
  }

  Future<void> addCategoryTipsFavorite(CategoryTipsFavorite favorite) async {
    try {
      final updatedFavorites = await _favoriteDao.addTipsFavorite(favorite);
      _favoriteCategoryTipsSubject.add(updatedFavorites);
    } catch (e) {
      throw RepositoryException('Failed to add tip favorite.', e);
    }
  }

  Future<void> updateCategoryTipsFavorites(List<CategoryTipsFavorite> favorites) async {
    try {
      await _favoriteDao.updateTipsFavorites(favorites);
      _favoriteCategoryTipsSubject.add(favorites);
    } catch (e) {
      throw RepositoryException('Failed to update tip favorites.', e);
    }
  }

  Future<void> removeCategoryTipsFavorite(CategoryTipsFavorite favorite) async {
    try {
      final updatedFavorites = await _favoriteDao.removeCategoryTipsFavorite(favorite);
      _favoriteCategoryTipsSubject.add(updatedFavorites);
    } catch (e) {
      throw RepositoryException('Failed to remove tip favorite.', e);
    }
  }

  void _initFavoriteProductsUpdates() {
    _favoriteProductsSubject = BehaviorSubject<Map<int?, List<ProductFavorite>>>(onListen: () {
      final favorites = _favoriteDao.getProductFavorites();
      _favoriteProductsSubject!.add(favorites);
    });
  }

  void _initFavoriteChecklistsUpdates() {
    _favoriteChecklistsSubject = BehaviorSubject<List<ChecklistFavorite>>(onListen: () {
      final favorites = _favoriteDao.getChecklistFavorites();
      _favoriteChecklistsSubject.add(favorites);
    });
  }

  void _initFavoriteLabelTipsUpdates() {
    _favoriteCategoryTipsSubject = BehaviorSubject<List<CategoryTipsFavorite>>(onListen: () {
      final favorites = _favoriteDao.getCategoryTipsFavorites();
      _favoriteCategoryTipsSubject.add(favorites);
    });
  }
}
