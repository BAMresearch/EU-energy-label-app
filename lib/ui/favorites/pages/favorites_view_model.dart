/* * Copyright 2020 Bundesanstalt für Materialforschung und -prüfung (BAM) *
* Licensed under the EUPL, Version 1.2 or – as soon they will be approved by the European Commission - subsequent versions of the EUPL (the "Licence");
* You may not use this work except in compliance with theLicence.
* You may obtain a copy of the Licence at:
* * https://joinup.ec.europa.eu/software/page/eupl *
* Unless required by applicable law or agreed to in writing, software distributed under the Licence is distributed on an "AS IS" basis,
* WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
* See the Licence for the specific language governing permissions and limitations under the Licence.*/

import 'dart:async';

import 'package:energielabel_app/data/favorite_repository.dart';
import 'package:energielabel_app/data/label_guide_repository.dart';
import 'package:energielabel_app/model/favorite.dart';
import 'package:energielabel_app/model/know_how/label_guide/label_category.dart';
import 'package:energielabel_app/model/pdf_page_data.dart';
import 'package:energielabel_app/ui/favorites/components/favorite_export_dialog.dart';
import 'package:energielabel_app/ui/favorites/favorite_list_item.dart';
import 'package:energielabel_app/ui/favorites/favorites_routes.dart';
import 'package:energielabel_app/ui/favorites/pages/favorite_type.dart';
import 'package:energielabel_app/ui/know_how/pages/label_guide/category_checklists_page.dart';
import 'package:energielabel_app/ui/know_how/pages/label_guide/category_tips_page.dart';
import 'package:energielabel_app/ui/misc/components/bam_dialog.dart';
import 'package:energielabel_app/ui/misc/pages/base_view_model.dart';
import 'package:energielabel_app/ui/misc/pages/view_state.dart';
import 'package:energielabel_app/ui/pdf/pdf_exporter.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_fimber/flutter_fimber.dart';
import 'package:flutter_gen/gen_l10n/translations.dart';
import 'package:pedantic/pedantic.dart';
import 'package:rxdart/rxdart.dart';
import 'package:synchronized/synchronized.dart';
import 'package:url_launcher/url_launcher.dart';

import 'favorites_edit_page.dart';

enum FavoritesTab { products, knowHow }

class FavoritesViewModel extends BaseViewModel {
  FavoritesViewModel({
    required BuildContext context,
    required FavoriteRepository favoriteRepository,
    required LabelGuideRepository labelGuideRepository,
  })   : _context = context,
        _favoriteRepository = favoriteRepository,
        _labelGuideRepository = labelGuideRepository;

  final BuildContext _context;
  final FavoriteRepository _favoriteRepository;
  final LabelGuideRepository _labelGuideRepository;
  final CompositeSubscription _subscriptions = CompositeSubscription();
  final List<FavoriteListSection> _favoriteProductListSections = [];
  final List<FavoriteListSection> _favoriteKnowHowListSections = [];
  ViewState _viewState = ViewState.uninitialized;
  FavoritesTab _selectedFavoritesTab = FavoritesTab.products;

  final _productListUpdateLock = Lock();

  List<FavoriteListSection> get favoriteProductListSections => List.unmodifiable(_favoriteProductListSections);

  List<FavoriteListSection> get favoriteKnowHowListSections => List.unmodifiable(_favoriteKnowHowListSections);

  ViewState get viewState => _viewState;

  FavoritesTab get selectedFavoritesTab => _selectedFavoritesTab;

  bool get isFavoritesEmpty => _favoriteProductListSections.isEmpty && _favoriteKnowHowListSections.isEmpty;

  @override
  void onViewStarted() {
    _observeFavoriteKnowHowEntries();
    _observeFavoriteProducts();
    _viewState = ViewState.initialized;
    notifyListeners();
  }

  @override
  void dispose() {
    _subscriptions.clear();
    super.dispose();
  }

  void onTabSelected(FavoritesTab favoritesTab) {
    _selectedFavoritesTab = favoritesTab;
    notifyListeners();
  }

  Future<void> onFavoriteSelected(FavoriteListSectionEntry entry) async {
    switch (entry.favoriteType) {
      case FavoriteType.products:
        final typedFavorite = entry.favorite as ProductFavorite;
        final String url = typedFavorite.product!.url!;
        if (await canLaunch(url)) {
          unawaited(launch(url, forceSafariVC: false));
        } else {
          Fimber.e('Failed to open browser for product.');
          // TODO Show a hint to the user, e.g. a snackBar.
        }
        break;
      case FavoriteType.checklists:
        final typedFavorite = entry.favorite as ChecklistFavorite;
        final labelCategory = await _labelGuideRepository.getCategory(typedFavorite.categoryId);

        unawaited(
          Navigator.of(_context).pushNamed(
            FavoritesRoutes.checklistDetails,
            arguments: CategoryChecklistPageArguments(labelCategory: labelCategory!),
          ),
        );
        break;
      case FavoriteType.tips:
        final typedFavorite = entry.favorite as CategoryTipsFavorite;
        final labelCategory = await _labelGuideRepository.getCategory(typedFavorite.categoryId);

        if (labelCategory != null) {
          unawaited(
            Navigator.of(_context).pushNamed(
              FavoritesRoutes.tipDetail,
              arguments: CategoryTipsPageArguments(labelCategory: labelCategory),
            ),
          );
        } else {
          Fimber.e('Label category not found for ID ${typedFavorite.categoryId}');
        }
        break;
    }
  }

  dynamic onEditFavoriteSection(FavoriteType favoriteType, int? categoryId) {
    Navigator.of(_context).pushNamed(FavoritesRoutes.editFavorites,
        arguments: FavoritesEditArguments(
          favoriteType: favoriteType,
          categoryId: categoryId,
        ));
    return null;
  }

  void _observeFavoriteProducts() {
    _subscriptions
        .add(_favoriteRepository.favoriteProductsUpdates!.listen(_handleProductFavoritesUpdates))
        .onError((error, stacktrace) {
      // TODO Show error to the user.
      Fimber.e('Failed to observe product favorites.', ex: error, stacktrace: stacktrace);
    });
  }

  // rxdart calls this method multiply times without considering async. To archive a sync call, the method needs a lock.
  void _handleProductFavoritesUpdates(Map<int?, List<ProductFavorite>> favoriteProducts) async {
    await _productListUpdateLock.synchronized(() async {
      _favoriteProductListSections.clear();

      final List<int?> categoryIds = favoriteProducts.keys.toList();
      categoryIds.sort((categoryId1, categoryId2) => categoryId1!.compareTo(categoryId2!));

      for (final categoryId in categoryIds) {
        final LabelCategory? category = await _labelGuideRepository.getCategoryForId(categoryId);
        if (favoriteProducts[categoryId]!.isNotEmpty) {
          _favoriteProductListSections.add(
            FavoriteListSection(
              title: category!.productType!,
              favoriteType: FavoriteType.products,
              productCategory: category.id,
              sectionEntries: [
                for (final favoriteProduct in favoriteProducts[categoryId]!)
                  FavoriteListSectionEntry(
                    title: favoriteProduct.title!,
                    favoriteType: FavoriteType.products,
                    favorite: favoriteProduct,
                  ),
              ],
            ),
          );
        }
      }
      notifyListeners();
    });
  }

  void _observeFavoriteKnowHowEntries() {
    _subscriptions.add(
      Rx.combineLatest2(
        _favoriteRepository.favoriteChecklistsUpdates,
        _favoriteRepository.favoriteCategoryTipsUpdates,
        _combineKnowHowFavorites,
      ).listen(
        (combineResultFuture) async {
          try {
            await combineResultFuture;
            notifyListeners();
          } catch (e, stacktrace) {
            // TODO Show error to the user.
            Fimber.e('Failed to combine know-how favorites.', ex: e, stacktrace: stacktrace);
          }
        },
        onError: (error, stacktrace) {
          // TODO Show error to the user.
          Fimber.e('Failed to observe know-how favorites.', ex: error, stacktrace: stacktrace);
        },
      ),
    );
  }

  Future<void> _combineKnowHowFavorites(
    List<ChecklistFavorite> favoriteChecklists,
    List<CategoryTipsFavorite> favoriteCategoryTips,
  ) async {
    _favoriteKnowHowListSections.clear();
    final allCategories = await _labelGuideRepository.getCategories();

    // Checklists
    if (favoriteChecklists.isNotEmpty) {
      // List of all categories containing checklist favorites
      final List<LabelCategory> favoriteCategories = favoriteChecklists
          .where((ChecklistFavorite favorite) => favorite.categoryId != null)
          .map((ChecklistFavorite favorite) =>
              allCategories.firstWhere((LabelCategory category) => favorite.categoryId == category.id))
          .toList();

      _favoriteKnowHowListSections.add(
        FavoriteListSection(
          title: Translations.of(_context)!.favorites_know_how_checklists_section_title,
          favoriteType: FavoriteType.checklists,
          sectionEntries: [
            for (final category in favoriteCategories)
              FavoriteListSectionEntry(
                title: category.productType!,
                favoriteType: FavoriteType.checklists,
                favorite: favoriteChecklists
                    .singleWhere((categoryChecklistFavorite) => categoryChecklistFavorite.categoryId == category.id),
              ),
          ],
        ),
      );
    }

    // Tips entries
    if (favoriteCategoryTips.isNotEmpty) {
      final List<LabelCategory> favoriteCategories = favoriteCategoryTips
          .map((favorite) => allCategories.firstWhere((tip) => favorite.categoryId == tip.id))
          .toList();

      _favoriteKnowHowListSections.add(
        FavoriteListSection(
          title: Translations.of(_context)!.favorites_label_tips_section_title,
          favoriteType: FavoriteType.tips,
          sectionEntries: [
            for (final category in favoriteCategories)
              FavoriteListSectionEntry(
                title: category.productType!,
                favoriteType: FavoriteType.tips,
                favorite: favoriteCategoryTips
                    .singleWhere((categoryTipFavorite) => categoryTipFavorite.categoryId == category.id),
              ),
          ],
        ),
      );
    }
  }

  void exportPdf() {
    showDialogWithBlur(
      context: _context,
      builder: (context) => FavoriteExportDialog(
        onExportConfirmed: _onExportConfirmed,
        isKnowHowEmpty: _favoriteKnowHowListSections.isEmpty,
        isProductsEmpty: _favoriteProductListSections.isEmpty,
      ),
    );
  }

  Future<void> _onExportConfirmed({bool? productsChecked = false, bool? knowHowChecked = false}) async {
    final List<PdfPageData> pagesToExport = [];
    final allCategories = await _labelGuideRepository.getCategories();

    if (productsChecked!) {
      final Map<String, List<ProductFavorite>> productsForCategories = {};
      for (final entry in _favoriteRepository.latestProductList!.entries) {
        final category = (await _labelGuideRepository.getCategory(entry.key));

        final categoryTitle = category!.productType!.replaceAll('\u00AD', '');
        productsForCategories[categoryTitle] = entry.value;
      }

      pagesToExport.add(ProductsPdfPageData(
        Translations.of(_context)!.pdf_products_category_title,
        productsForCategories,
      ));
    }

    if (knowHowChecked!) {
      final checkListPdfPages = _favoriteRepository.latestChecklistsList!.map((checklist) async {
        final category = allCategories.where((element) => element.checklistData!.id == checklist.categoryId).first;
        final checklistData = category.checklistData!;
        final categoryTitle = category.productType!.replaceAll('\u00AD', '');

        for (final labelCategoryChecklist in checklistData.checklists!) {
          for (final checklistEntry in labelCategoryChecklist.checklistEntries!) {
            checklistEntry.checked =
                _labelGuideRepository.getCheckboxEntryState(checklistEntry.id, labelCategoryChecklist.id);
          }
        }

        return ChecklistPdfPageData(Translations.of(_context)!.pdf_know_how_category_title,
            Translations.of(_context)!.pdf_know_how_checklists_category(categoryTitle), checklistData);
      });
      pagesToExport.addAll(await Future.wait(checkListPdfPages));

      pagesToExport.addAll(_favoriteRepository.latestCategoryTipsFavoriteList!.map((tip) {
        final category = allCategories.where((element) => element.checklistData!.id == tip.categoryId).first;
        final categoryTitle = category.productType!.replaceAll('\u00AD', '');

        return TipsPdfPageData(Translations.of(_context)!.pdf_know_how_category_title,
            Translations.of(_context)!.pdf_know_how_tips_category(categoryTitle), category.tipData);
      }));
    }

    final PdfExporter pdfExporter = PdfExporter(
        targetFileName: '${Translations.of(_context)!.pdf_filename}.pdf',
        pagesData: pagesToExport,
        buildContext: _context);

    //generate pdf and show in preview
    final String pdfPath = await pdfExporter.exportPdf();
    unawaited(Navigator.of(_context).pushNamed(FavoritesRoutes.exportPreview, arguments: pdfPath));
  }
}
