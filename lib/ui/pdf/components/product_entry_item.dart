/* * Copyright 2020 Bundesanstalt für Materialforschung und -prüfung (BAM) *
* Licensed under the EUPL, Version 1.2 or – as soon they will be approved by the European Commission - subsequent versions of the EUPL (the "Licence");
* You may not use this work except in compliance with theLicence.
* You may obtain a copy of the Licence at:
* * https://joinup.ec.europa.eu/software/page/eupl *
* Unless required by applicable law or agreed to in writing, software distributed under the Licence is distributed on an "AS IS" basis,
* WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
* See the Licence for the specific language governing permissions and limitations under the Licence.*/

import 'package:energielabel_app/data/asset_paths.dart';
import 'package:energielabel_app/model/favorite.dart';
import 'package:energielabel_app/ui/misc/theme/bam_colors.dart';
import 'package:energielabel_app/ui/pdf/resources/svg_asset.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart';

class ProductEntryItem extends StatelessWidget {
  ProductEntryItem(this.productFavorite);

  final ProductFavorite productFavorite;

  @override
  Widget build(Context context) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(productFavorite.title ?? productFavorite.product.title, style: Theme.of(context).header1),
          UrlLink(
            destination: productFavorite.product.url,
            child: Padding(
              padding: EdgeInsets.symmetric(vertical: 8),
              child: Row(crossAxisAlignment: CrossAxisAlignment.center, children: [
                SvgImage(svg: SvgAsset.getSvgString(context, AssetPaths.externalLinkIcon), height: 12),
                SizedBox(width: 8),
                Text(productFavorite.product.url,
                    style: Theme.of(context)
                        .defaultTextStyle
                        .copyWith(color: PdfColor.fromInt(BamColorPalette.bamBlue1Optimized.value))),
              ]),
            ),
          ),
        ],
      ),
    );
  }
}
