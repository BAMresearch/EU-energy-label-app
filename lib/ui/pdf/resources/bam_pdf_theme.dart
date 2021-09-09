/* * Copyright 2020 Bundesanstalt für Materialforschung und -prüfung (BAM) *
* Licensed under the EUPL, Version 1.2 or – as soon they will be approved by the European Commission - subsequent versions of the EUPL (the "Licence");
* You may not use this work except in compliance with theLicence.
* You may obtain a copy of the Licence at:
* * https://joinup.ec.europa.eu/software/page/eupl *
* Unless required by applicable law or agreed to in writing, software distributed under the Licence is distributed on an "AS IS" basis,
* WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
* See the Licence for the specific language governing permissions and limitations under the Licence.*/

import 'package:energielabel_app/ui/misc/theme/bam_colors.dart';
import 'package:energielabel_app/ui/misc/theme/bam_text_theme.dart';
import 'package:flutter/services.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart';

class BamPdfTheme {
  BamPdfTheme();

  Font? regularFont;
  Font? mediumFont;

  PdfColor bamBlue3 = PdfColor.fromInt(BamColorPalette.bamBlue3.value);
  PdfColor bamBlack80 = PdfColor.fromInt(BamColorPalette.bamBlack80.value);
  PdfColor bamBlack30 = PdfColor.fromInt(BamColorPalette.bamBlack30.value);
  PdfColor bamBlack60Optimized = PdfColor.fromInt(BamColorPalette.bamBlack60Optimized.value);

  Future<void> loadFonts() async {
    regularFont = Font.helvetica();
    mediumFont = Font.helvetica();
  }

  ThemeData createTheme() {
    assert(regularFont != null);
    assert(mediumFont != null);

    return ThemeData(
      defaultTextStyle:
          TextStyle(font: regularFont, fontSize: 14, height: BamTextStyles.body2.height, color: bamBlack80),
      header0: TextStyle(
          font: regularFont,
          fontSize: BamTextStyles.headline1.fontSize,
          height: BamTextStyles.headline1.height,
          color: bamBlue3),
      header1: TextStyle(
          font: regularFont,
          fontSize: BamTextStyles.headline2.fontSize,
          height: BamTextStyles.headline2.height,
          color: bamBlue3),
      header2: TextStyle(
          font: regularFont,
          fontSize: BamTextStyles.headline3.fontSize,
          height: BamTextStyles.headline3.height,
          color: bamBlue3),
      header3: TextStyle(
          font: regularFont,
          fontSize: BamTextStyles.headline4.fontSize,
          height: BamTextStyles.headline4.height,
          color: bamBlack60Optimized),
      header4: TextStyle(
          font: regularFont, fontSize: BamTextStyles.headline5.fontSize, height: BamTextStyles.headline5.height),
      header5: TextStyle(
          font: regularFont, fontSize: BamTextStyles.headline6.fontSize, height: BamTextStyles.headline6.height),
    );
  }
}
