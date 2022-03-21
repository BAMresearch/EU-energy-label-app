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

import 'package:energielabel_app/app_uri_schemes.dart';
import 'package:energielabel_app/data/favorite_repository.dart';
import 'package:energielabel_app/data/label_guide_repository.dart';
import 'package:energielabel_app/model/favorite.dart';
import 'package:energielabel_app/model/know_how/label_guide/label_category.dart';
import 'package:energielabel_app/ui/know_how/favorite_action_listener.dart';
import 'package:energielabel_app/ui/know_how/know_how_routes.dart';
import 'package:energielabel_app/ui/know_how/pages/label_guide/category_checklists_page.dart';
import 'package:energielabel_app/ui/misc/pages/base_view_model.dart';
import 'package:energielabel_app/ui/misc/tab_routes.dart';
import 'package:flutter/cupertino.dart';

class CategoryTipsViewModel extends BaseViewModel {
  CategoryTipsViewModel({
    required LabelCategory labelCategory,
    required FavoriteRepository favoriteRepository,
    required LabelGuideRepository labelGuideRepository,
    required FavoriteActionListener favoriteActionListener,
    required BuildContext context,
  })  : _categoryTipsFavorite = CategoryTipsFavorite(categoryId: labelCategory.id),
        _favoriteRepository = favoriteRepository,
        _favoriteActionListener = favoriteActionListener,
        _labelGuideRepository = labelGuideRepository,
        _context = context;

  final BuildContext _context;
  final CategoryTipsFavorite _categoryTipsFavorite;
  final FavoriteRepository _favoriteRepository;
  final LabelGuideRepository _labelGuideRepository;
  final FavoriteActionListener _favoriteActionListener;
  bool _isFavorite = false;

  bool get isFavorite => _isFavorite;

  @override
  FutureOr<void> onViewStarted() {
    _observeFavoriteUpdates();
  }

  void onToggleFavoriteAction() {
    _isFavorite ? _removeFavorite() : _addFavorite();
    notifyListeners();
  }

  Future<void> _addFavorite() async {
    try {
      await _favoriteRepository.addCategoryTipsFavorite(_categoryTipsFavorite);
      _favoriteActionListener.onAddFavoriteSuccess();
    } catch (e, stacktrace) {
      log('Failed to add favorite.', error: e, stackTrace: stacktrace);
      _favoriteActionListener.onAddFavoriteFailure();
    }
  }

  Future<void> _removeFavorite() async {
    try {
      await _favoriteRepository.removeCategoryTipsFavorite(_categoryTipsFavorite);
      _favoriteActionListener.onRemoveFavoriteSuccess();
    } catch (e) {
      log('Failed to remove favorite.', error: e);
      _favoriteActionListener.onRemoveFavoriteFailure();
    }
  }

  void _observeFavoriteUpdates() {
    subscriptions.add(
      _favoriteRepository.favoriteCategoryTipsUpdates.listen((favorites) {
        _isFavorite = favorites.contains(_categoryTipsFavorite);
        notifyListeners();
      })
        ..onError(
          (e, stacktrace) {
            log('Failed to observe favorite state.', error: e, stackTrace: stacktrace);
            // TODO Show error message to user?
          },
        ),
    );
  }

  Future<bool> onLinkTap(String? link) async {
    final Uri uri = Uri.parse(link ?? '');

    if (uri.isScheme(AppUriSchemes.appScheme) && uri.path == AppUriSchemes.pushPagePath && uri.hasQuery) {
      final TabRoute? tabRoute = TabRoutes.getRoute(
          uri.queryParameters[AppUriSchemes.queryParameterTab], uri.queryParameters[AppUriSchemes.queryParameterPage]);
      if (tabRoute != null &&
          tabRoute.runtimeType == KnowHowRoutes &&
          tabRoute.route == KnowHowRoutes.labelGuideCategoryChecklists) {
        final LabelCategory labelCategory = await (_labelGuideRepository.getCategoryForId(
            int.parse(uri.queryParameters[AppUriSchemes.queryParameterArguments]!)) as FutureOr<LabelCategory>);

        final CategoryChecklistPageArguments categoryChecklistPageArguments =
            CategoryChecklistPageArguments(labelCategory: labelCategory);

        unawaited(Navigator.of(_context).pushNamed(tabRoute.route!, arguments: categoryChecklistPageArguments));

        return true;
      }
    }
    return false;
  }
}
