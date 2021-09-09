/* * Copyright 2020 Bundesanstalt für Materialforschung und -prüfung (BAM) *
* Licensed under the EUPL, Version 1.2 or – as soon they will be approved by the European Commission - subsequent versions of the EUPL (the "Licence");
* You may not use this work except in compliance with theLicence.
* You may obtain a copy of the Licence at:
* * https://joinup.ec.europa.eu/software/page/eupl *
* Unless required by applicable law or agreed to in writing, software distributed under the Licence is distributed on an "AS IS" basis,
* WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
* See the Licence for the specific language governing permissions and limitations under the Licence.*/

import 'package:energielabel_app/data/asset_paths.dart';
import 'package:energielabel_app/ui/misc/theme/bam_colors.dart';
import 'package:energielabel_app/ui/pdf/resources/svg_asset.dart';
import 'package:energielabel_app/ui/pdf/utils/pdf_html_utils.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart';

class GeneralInfoBox extends StatelessWidget {
  GeneralInfoBox({
    required this.content,
    this.title,
  });

  final String? title;
  final String content;

  @override
  Widget build(Context context) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 16),
      child: DecoratedBox(
        decoration: BoxDecoration(
          color: PdfColor.fromInt(BamColorPalette.bamWhite.value),
          borderRadius: BorderRadius.circular(8),
          border: Border.all(width: 2, color: PdfColor.fromInt(BamColorPalette.bamYellow2.value)),
        ),
        child: Padding(
            padding: EdgeInsets.all(20), child: title != null ? _buildWithTitle(context) : _buildWithoutTitle(context)),
      ),
    );
  }

  Widget _buildWithTitle(Context context) {
    return Column(children: [
      Row(
        children: [
          SvgImage(svg: SvgAsset.getSvgString(context, AssetPaths.knowHowLightBulbIcon)!),
          SizedBox(width: 20),
          Expanded(
            child: Text(
              title!,
              style: Theme.of(context).header2.copyWith(color: PdfColor.fromInt(BamColorPalette.bamYellow2.value)),
            ),
          ),
        ],
      ),
      SizedBox(height: 16),
      PdfHtmlUtils.htmlStringToPdfWidget(context, content),
    ]);
  }

  Widget _buildWithoutTitle(Context context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SvgImage(svg: SvgAsset.getSvgString(context, AssetPaths.knowHowLightBulbIcon)!),
        SizedBox(width: 20),
        Expanded(
          child: Text(content),
        ),
      ],
    );
  }
}
