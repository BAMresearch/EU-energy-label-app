/* * Copyright 2020 Bundesanstalt für Materialforschung und -prüfung (BAM) *
* Licensed under the EUPL, Version 1.2 or – as soon they will be approved by the European Commission - subsequent versions of the EUPL (the "Licence");
* You may not use this work except in compliance with theLicence.
* You may obtain a copy of the Licence at:
* * https://joinup.ec.europa.eu/software/page/eupl *
* Unless required by applicable law or agreed to in writing, software distributed under the Licence is distributed on an "AS IS" basis,
* WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
* See the Licence for the specific language governing permissions and limitations under the Licence.*/

import 'dart:io';

import 'package:energielabel_app/model/favorite.dart';
import 'package:energielabel_app/model/pdf_page_data.dart';
import 'package:energielabel_app/ui/pdf/bam_page.dart';
import 'package:energielabel_app/ui/pdf/pages/checklist_page.dart';
import 'package:energielabel_app/ui/pdf/pages/product_page.dart';
import 'package:energielabel_app/ui/pdf/pages/tips_page.dart';
import 'package:energielabel_app/ui/pdf/resources/bam_pdf_theme.dart';
import 'package:energielabel_app/ui/pdf/resources/pdf_assets.dart';
import 'package:energielabel_app/ui/pdf/resources/svg_asset.dart';
import 'package:energielabel_app/ui/pdf/utils/document_extension.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart' as flutter_widgets;
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:pdf/widgets.dart';

class PdfExporter {
  PdfExporter({
    this.targetFileName = 'PDFExport.pdf',
    required this.pagesData,
    required this.buildContext,
  });

  final String targetFileName;
  final List<PdfPageData> pagesData;
  final flutter_widgets.BuildContext buildContext;

  Future<String> exportPdf() async {
    final Directory appDocDir = await getApplicationDocumentsDirectory();

    final SvgAssetData preloadedSvgAssets = SvgAssetData(await preloadSvgAssets(PdfAssets.svgAssets));

    final BamPdfTheme pdfTheme = BamPdfTheme();
    await pdfTheme.loadFonts();

    final Document pdf = Document(
      theme: pdfTheme.createTheme(),
    );

    for (final pageData in pagesData) {
      await pdf.addBamPage(BamPdfPage(
        buildContext: buildContext,
        pageCategory: pageData.pageCategory,
        titleSubCategory: pageData.titleProductCategory,
        preloadedAssets: preloadedSvgAssets,
        build: (context) => _buildPages(pageData),
      ));
    }

    //export pdf file
    final file = File(join(appDocDir.path, targetFileName));
    final bytes = await pdf.save();
    final File generatedPdfFile = await file.writeAsBytes(bytes);

    return generatedPdfFile.path;
  }

  Future<Map<String, String>> preloadSvgAssets(List<String> assetPaths) async {
    final Map<String, String> preloadedSvgAssets = {};
    for (final String assetPath in assetPaths) {
      preloadedSvgAssets[assetPath] = await rootBundle.loadString(assetPath);
    }
    return preloadedSvgAssets;
  }

  StatelessMultiPage _buildPages(PdfPageData pageData) {
    switch (pageData.runtimeType) {
      case ChecklistPdfPageData:
        return _buildChecklists(pageData as ChecklistPdfPageData);
      case TipsPdfPageData:
        return _buildTips(pageData as TipsPdfPageData);
      case ProductsPdfPageData:
        return _buildProducts(pageData as ProductsPdfPageData);
      default:
        throw ArgumentError('PageType does not exist!');
    }
  }

  StatelessMultiPage _buildChecklists(ChecklistPdfPageData pageData) {
    final data = pageData.checklistData;

    return ChecklistPage(checklistData: data);
  }

  StatelessMultiPage _buildTips(TipsPdfPageData pageData) {
    final data = pageData.tipsData!;

    return TipsPage(tipsData: data);
  }

  StatelessMultiPage _buildProducts(ProductsPdfPageData pageData) {
    final Map<String, List<ProductFavorite>> data = pageData.productData;

    return ProductPage(productData: data);
  }
}
