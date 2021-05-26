/* * Copyright 2020 Bundesanstalt für Materialforschung und -prüfung (BAM) *
* Licensed under the EUPL, Version 1.2 or – as soon they will be approved by the European Commission - subsequent versions of the EUPL (the "Licence");
* You may not use this work except in compliance with theLicence.
* You may obtain a copy of the Licence at:
* * https://joinup.ec.europa.eu/software/page/eupl *
* Unless required by applicable law or agreed to in writing, software distributed under the Licence is distributed on an "AS IS" basis,
* WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
* See the Licence for the specific language governing permissions and limitations under the Licence.*/

import 'package:energielabel_app/ui/misc/theme/bam_colors.dart';
import 'package:flutter/foundation.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart';

class BamHeader extends StatelessWidget {
  BamHeader({
    @required this.pageCategory,
    this.titleSubCategory,
  })  : assert(pageCategory != null);

  final String pageCategory;
  final String titleSubCategory;

  @override
  Widget build(Context context) {
    return Padding(
      padding: EdgeInsets.only(bottom: 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              if (titleSubCategory == null) SizedBox(height: 24),
              Text(
                pageCategory.toUpperCase(),
                style: TextStyle.defaultStyle().copyWith(
                  fontSize: 12,
                  color: PdfColor.fromInt(BamColorPalette.bamBlack30.value),
                ),
              ),
              if (titleSubCategory != null)
                Text(
                  titleSubCategory.toUpperCase(),
                  style: Theme.of(context).header3,
                ),
            ],
          ),
        ],
      ),
    );
  }
}
