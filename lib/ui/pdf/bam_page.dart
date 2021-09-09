/* * Copyright 2020 Bundesanstalt für Materialforschung und -prüfung (BAM) *
* Licensed under the EUPL, Version 1.2 or – as soon they will be approved by the European Commission - subsequent versions of the EUPL (the "Licence");
* You may not use this work except in compliance with theLicence.
* You may obtain a copy of the Licence at:
* * https://joinup.ec.europa.eu/software/page/eupl *
* Unless required by applicable law or agreed to in writing, software distributed under the Licence is distributed on an "AS IS" basis,
* WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
* See the Licence for the specific language governing permissions and limitations under the Licence.*/

import 'dart:typed_data';

import 'package:energielabel_app/data/asset_paths.dart';
import 'package:energielabel_app/service_locator.dart';
import 'package:energielabel_app/ui/pdf/components/bam_header.dart';
import 'package:energielabel_app/ui/pdf/resources/svg_asset.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart' as flutter_widgets;
import 'package:flutter_gen/gen_l10n/translations.dart';
import 'package:package_info/package_info.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart';

typedef MultiPageBuilder = StatelessMultiPage Function(Context context);

abstract class BamPage {
  Future<void> initPage() async {}

  Page buildPage();
}

abstract class StatelessMultiPage {
  List<Widget> build();
}

class BamPdfPage extends BamPage {
  BamPdfPage({
    required this.pageCategory,
    this.titleSubCategory,
    required this.preloadedAssets,
    required this.build,
    required this.buildContext,
  });

  final flutter_widgets.BuildContext buildContext;
  final String pageCategory;
  final String? titleSubCategory;
  final SvgAssetData preloadedAssets;
  final MultiPageBuilder build;

  Uint8List? _appIconData;
  PackageInfo? _packageInfo;

  @override
  Future<void> initPage() async {
    _appIconData = (await rootBundle.load(AssetPaths.appIconImage)).buffer.asUint8List();

    _packageInfo = ServiceLocator().get<PackageInfo>();
  }

  @override
  Page buildPage() {
    return MultiPage(
      header: (context) => BamHeader(
        pageCategory: pageCategory,
        titleSubCategory: titleSubCategory,
        svgLogo: preloadedAssets.getSvgAsset(AssetPaths.logoBlackImage)!,
      ),
      footer: (context) => Footer(
        leading: Row(
          children: [
            if (_appIconData != null) Image(MemoryImage(_appIconData!), height: 20, width: 20),
            UrlLink(
                destination: Translations.of(buildContext)!.pdf_footer_link,
                child: Text('${_packageInfo!.appName} (${_packageInfo!.version}+${_packageInfo!.buildNumber})')),
          ],
        ),
        trailing: Text('${context.pageNumber}'),
      ),
      pageFormat: PdfPageFormat.a4,
      build: (context) => build(context).build().map((child) => SvgAsset(data: preloadedAssets, child: child)).toList(),
    );
  }
}
