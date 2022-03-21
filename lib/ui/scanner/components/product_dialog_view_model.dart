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
import 'package:energielabel_app/model/know_how/label_guide/label_category.dart';
import 'package:energielabel_app/model/scanner/product.dart';
import 'package:energielabel_app/ui/misc/pages/base_view_model.dart';
import 'package:flutter/cupertino.dart';
import 'package:url_launcher/url_launcher.dart';

enum ProductDialogPage { dialogOverview, favoriteSetName, favoriteSetCategory, favoriteAddComment }

enum ProductDialogFinishAction { cancel, website, favorite }

class ProductDialogViewModel extends BaseViewModel {
  ProductDialogViewModel({
    required BuildContext context,
    required Product product,
    required Function(ProductDialogFinishAction) onFinishDialog,
    required FavoriteRepository favoriteRepository,
    required LabelGuideRepository labelGuideRepository,
  })  : _product = product,
        _context = context,
        _onFinishDialog = onFinishDialog,
        _favoriteRepository = favoriteRepository,
        _labelGuideRepository = labelGuideRepository;

  final BuildContext _context;
  final Product _product;
  final Function(ProductDialogFinishAction) _onFinishDialog;
  final FavoriteRepository _favoriteRepository;
  final LabelGuideRepository _labelGuideRepository;
  final List<LabelCategory> _labelCategories = [];
  ProductDialogPage _visiblePage = ProductDialogPage.dialogOverview;
  late ProductFavorite _productFavorite;

  List<LabelCategory> get labelCategories => List.unmodifiable(_labelCategories);

  String? get productUrl => _product.url;

  ProductDialogPage get visiblePage => _visiblePage;

  @override
  Future<void> onViewStarted() async {
    await _loadLabelCategories();
    notifyListeners();
  }

  void onBrowserOpenAction() async {
    Navigator.of(_context).pop();
    if (await canLaunch(productUrl!)) {
      unawaited(launch(productUrl!, forceSafariVC: false));
    } else {
      log('Failed to open browser for product.');
      // TODO Show a hint to the user, e.g. a snackBar.
    }
    _onFinishDialog(ProductDialogFinishAction.website);
  }

  void onCancelDialog() {
    Navigator.of(_context).pop();
    _onFinishDialog(ProductDialogFinishAction.cancel);
  }

  void onShowFavoriteSetNamePage() {
    _visiblePage = ProductDialogPage.favoriteSetName;
    notifyListeners();
  }

  void onConfirmSetName(String name) {
    _productFavorite = ProductFavorite(title: name, product: _product);

    _visiblePage = ProductDialogPage.favoriteSetCategory;
    notifyListeners();
  }

  void onAddComment(String comment) {
    _productFavorite = _productFavorite.copyWith(comments: [comment]);
    notifyListeners();
    onFavoriteConfirmationAction();
  }

  void onFavoriteConfirmationAction() {
    Navigator.pop(_context);
    _onFinishDialog(ProductDialogFinishAction.favorite);
    _favoriteRepository.addProductFavorite(_productFavorite);
  }

  void onCategoryConfirmationAction(LabelCategory? category) {
    if (category != null) {
      _productFavorite = _productFavorite.copyWith(categoryId: category.id);
    }
    _visiblePage = ProductDialogPage.favoriteAddComment;
    notifyListeners();
  }

  Future<void> _loadLabelCategories() async {
    final labelCategories = await _labelGuideRepository.getCategories();
    _labelCategories.addAll(labelCategories.where((labelCategory) => labelCategory.visible == true));
  }
}
