/* * Copyright 2020 Bundesanstalt für Materialforschung und -prüfung (BAM) *
* Licensed under the EUPL, Version 1.2 or – as soon they will be approved by the European Commission - subsequent versions of the EUPL (the "Licence");
* You may not use this work except in compliance with theLicence.
* You may obtain a copy of the Licence at:
* * https://joinup.ec.europa.eu/software/page/eupl *
* Unless required by applicable law or agreed to in writing, software distributed under the Licence is distributed on an "AS IS" basis,
* WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
* See the Licence for the specific language governing permissions and limitations under the Licence.*/

import 'package:energielabel_app/data/asset_paths.dart';
import 'package:energielabel_app/service_locator.dart';
import 'package:energielabel_app/ui/misc/components/error_view.dart';
import 'package:energielabel_app/ui/misc/page_scaffold.dart';
import 'package:energielabel_app/ui/misc/pages/base_page.dart';
import 'package:energielabel_app/ui/misc/pages/pdf_view_view_model.dart';
import 'package:energielabel_app/ui/misc/pages/view_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_cached_pdfview/flutter_cached_pdfview.dart';
import 'package:flutter_gen/gen_l10n/translations.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:provider/provider.dart';

enum PathType { assetPath, documentFolderPath }

class PdfViewPage extends StatelessPage<PdfViewViewModel> {
  PdfViewPage._({
    required this.pageTitle,
    required this.pathType,
    required this.pdfPath,
    this.isShareActionAllowed = false,
  });

  factory PdfViewPage.fromAssetPath({
    required String pageTitle,
    required String pdfAssetPath,
    bool isShareActionAllowed = false,
  }) {
    return PdfViewPage._(
      pageTitle: pageTitle,
      pdfPath: pdfAssetPath,
      pathType: PathType.assetPath,
      isShareActionAllowed: isShareActionAllowed,
    );
  }

  factory PdfViewPage.fromPath({
    required String pageTitle,
    required String pdfDocumentFolderPath,
    bool isShareActionAllowed = true,
  }) {
    return PdfViewPage._(
      pageTitle: pageTitle,
      pdfPath: pdfDocumentFolderPath,
      pathType: PathType.documentFolderPath,
      isShareActionAllowed: isShareActionAllowed,
    );
  }

  final bool isShareActionAllowed;
  final String pageTitle;
  final String pdfPath;
  final PathType pathType;

  final _shareButtonKey = GlobalKey();

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<PdfViewViewModel>(
      create: (context) => createViewModel(context)..onViewStarted(),
      child: Consumer<PdfViewViewModel>(builder: (context, viewModel, _) {
        return PageScaffold(
          actions: [
            if (isShareActionAllowed)
              IconButton(
                key: _shareButtonKey,
                icon: SvgPicture.asset(
                  AssetPaths.shareIcon,
                  semanticsLabel: Translations.of(context)!.share_page_share_button,
                ),
                onPressed: () => viewModel.onShareContent(context),
              )
          ],
          title: pageTitle,
          body: _buildBody(viewModel),
        );
      }),
    );
  }

  Widget _buildBody(PdfViewViewModel viewModel) {
    switch (viewModel.viewState) {
      case ViewState.uninitialized:
        return SizedBox.shrink();
      case ViewState.error:
        return _buildErrorView();
      default:
        return Stack(children: [
          _buildPdfView(viewModel),
          Visibility(
            visible: viewModel.viewState == ViewState.initializing,
            child: _buildProgressView(),
          ),
        ]);
    }
  }

  @override
  PdfViewViewModel createViewModel(BuildContext context) {
    return PdfViewViewModel(
      pdfPath: pdfPath,
      pathType: pathType,
      assetBundle: ServiceLocator().get<AssetBundle>()!,
      shareButtonKey: _shareButtonKey,
    );
  }

  Widget _buildProgressView() {
    return Center(child: CircularProgressIndicator());
  }

  Widget _buildPdfView(PdfViewViewModel viewModel) {
    final PDF pdf = PDF(
      preventLinkNavigation: true,
      pageSnap: false,
      onViewCreated: (_) => viewModel.onContentLoaded(),
      onError: viewModel.onPdfError,
    );
    return pathType == PathType.assetPath ? pdf.fromAsset(pdfPath) : pdf.fromPath(pdfPath);
  }

  Widget _buildErrorView() {
    return ErrorView();
  }
}
