/* * Copyright 2020 Bundesanstalt für Materialforschung und -prüfung (BAM) *
* Licensed under the EUPL, Version 1.2 or – as soon they will be approved by the European Commission - subsequent versions of the EUPL (the "Licence");
* You may not use this work except in compliance with theLicence.
* You may obtain a copy of the Licence at:
* * https://joinup.ec.europa.eu/software/page/eupl *
* Unless required by applicable law or agreed to in writing, software distributed under the Licence is distributed on an "AS IS" basis,
* WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
* See the Licence for the specific language governing permissions and limitations under the Licence.*/

import 'package:energielabel_app/data/favorite_repository.dart';
import 'package:energielabel_app/data/label_guide_repository.dart';
import 'package:energielabel_app/model/scanner/product.dart';
import 'package:energielabel_app/service_locator.dart';
import 'package:energielabel_app/ui/misc/components/bam_dialog.dart';
import 'package:energielabel_app/ui/misc/pages/base_page.dart';
import 'package:energielabel_app/ui/scanner/components/product_dialog_favorite_set_category.dart';
import 'package:energielabel_app/ui/scanner/components/product_dialog_favorite_set_name.dart';
import 'package:energielabel_app/ui/scanner/components/product_dialog_overview.dart';
import 'package:energielabel_app/ui/scanner/components/product_dialog_view_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/translations.dart';
import 'package:provider/provider.dart';

class ProductDialog extends StatelessPage<ProductDialogViewModel> {
  ProductDialog({
    @required Product product,
    @required Function(ProductDialogFinishAction) onFinish,
  })  : assert(product != null),
        assert(onFinish != null),
        _product = product,
        _onFinish = onFinish;

  final Product _product;
  final Function(ProductDialogFinishAction) _onFinish;

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<ProductDialogViewModel>(
      create: (context) => createViewModel(context)..onViewStarted(),
      child: Consumer<ProductDialogViewModel>(builder: (context, viewModel, _) {
        return BamDialog.custom(
          title: _buildTitle(context, viewModel),
          isScrollable: viewModel.visiblePage != ProductDialogPage.dialogOverview,
          builder: (context) {
            switch (viewModel.visiblePage) {
              case ProductDialogPage.dialogOverview:
                return ProductDialogOverview(
                  message: Translations.of(context).qrcode_product_dialog_message,
                  onTapOpenBrowser: viewModel.onBrowserOpenAction,
                  onTapFavorite: viewModel.onShowFavoriteSetNamePage,
                  onTapCancel: viewModel.onCancelDialog,
                );
              case ProductDialogPage.favoriteSetName:
                return ProductDialogFavoriteSetName(
                  onConfirmName: viewModel.onConfirmSetName,
                  onTapCancel: viewModel.onCancelDialog,
                );
              case ProductDialogPage.favoriteSetCategory:
                return ProductDialogFavoriteSetCategory(
                  labelCategories: viewModel.labelCategories,
                  onConfirmCategory: viewModel.onFavoriteConfirmationAction,
                  onTapCancel: viewModel.onCancelDialog,
                );
              default:
                throw ArgumentError.notNull('visiblePage');
            }
          },
        );
      }),
    );
  }

  String _buildTitle(BuildContext context, ProductDialogViewModel viewModel) {
    switch (viewModel.visiblePage) {
      case ProductDialogPage.dialogOverview:
        return Translations.of(context).qrcode_product_dialog_title;
      case ProductDialogPage.favoriteSetName:
        return Translations.of(context).product_favorite_dialog_set_title;
      case ProductDialogPage.favoriteSetCategory:
        return Translations.of(context).product_favorite_dialog_set_category;
      default:
        throw ArgumentError.notNull('visiblePage');
    }
  }

  @override
  ProductDialogViewModel createViewModel(BuildContext context) {
    return ProductDialogViewModel(
      context: context,
      product: _product,
      onFinishDialog: _onFinish,
      favoriteRepository: ServiceLocator().get<FavoriteRepository>(),
      labelGuideRepository: ServiceLocator().get<LabelGuideRepository>(),
    );
  }
}
