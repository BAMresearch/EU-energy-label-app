/* * Copyright 2020 Bundesanstalt für Materialforschung und -prüfung (BAM) *
* Licensed under the EUPL, Version 1.2 or – as soon they will be approved by the European Commission - subsequent versions of the EUPL (the "Licence");
* You may not use this work except in compliance with theLicence.
* You may obtain a copy of the Licence at:
* * https://joinup.ec.europa.eu/software/page/eupl *
* Unless required by applicable law or agreed to in writing, software distributed under the Licence is distributed on an "AS IS" basis,
* WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
* See the Licence for the specific language governing permissions and limitations under the Licence.*/

import 'package:energielabel_app/ui/misc/theme/bam_button_themes.dart';
import 'package:energielabel_app/ui/misc/theme/bam_colors.dart';
import 'package:energielabel_app/ui/misc/theme/bam_text_theme.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class BamTheme {
  BamTheme._();

  static final ThemeData themeData = ThemeData.from(colorScheme: BamColorScheme.colorScheme).copyWith(
    // App bar
    appBarTheme: AppBarTheme(iconTheme: IconThemeData(color: BamColorPalette.bamBlack)),

    // Texts
    textTheme: BamTextTheme.textTheme,

    // Buttons
    textButtonTheme: BamButtonThemes.textButtonTheme,
    elevatedButtonTheme: BamButtonThemes.elevatedButtonTheme,
    outlinedButtonTheme: BamButtonThemes.outlinedButtonTheme,

    // Icons
    iconTheme: IconThemeData(color: BamColorScheme.colorScheme.secondary),
  );
}
