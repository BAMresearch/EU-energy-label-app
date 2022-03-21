/* * Copyright 2020 Bundesanstalt für Materialforschung und -prüfung (BAM) *
* Licensed under the EUPL, Version 1.2 or – as soon they will be approved by the European Commission - subsequent versions of the EUPL (the "Licence");
* You may not use this work except in compliance with theLicence.
* You may obtain a copy of the Licence at:
* * https://joinup.ec.europa.eu/software/page/eupl *
* Unless required by applicable law or agreed to in writing, software distributed under the Licence is distributed on an "AS IS" basis,
* WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
* See the Licence for the specific language governing permissions and limitations under the Licence.*/

import 'package:energielabel_app/ui/misc/theme/bam_colors.dart';
import 'package:flutter/material.dart';

class BamTextTheme {
  BamTextTheme._();

  static const TextTheme textTheme = TextTheme(
    /// Extremely large text.
    headline1: BamTextStyles.headline1,

    /// Very, very large text.
    ///
    /// Used for the date in the dialog shown by [showDatePicker].
    headline2: BamTextStyles.headline2,

    /// Very large text.
    headline3: BamTextStyles.headline3,

    /// Large text.
    headline4: BamTextStyles.headline4,

    /// Used for large text in dialogs (e.g., the month and year in the dialog
    /// shown by [showDatePicker]).
    headline5: BamTextStyles.headline5,

    /// Used for the primary text in app bars and dialogs (e.g., [AppBar.title]
    /// and [AlertDialog.title]).
    headline6: BamTextStyles.headline6,

    /// Used for the primary text in lists (e.g., [ListTile.title]).
    subtitle1: BamTextStyles.subtitle1,

    /// For medium emphasis text that's a little smaller than [subtitle1].
    subtitle2: BamTextStyles.subtitle2,

    /// Used for emphasizing text that would otherwise be [bodyText2].
    bodyText1: BamTextStyles.body1,

    /// The default text style for [Material].
    bodyText2: BamTextStyles.body2,

    /// Used for auxiliary text associated with images.
    caption: BamTextStyles.caption,

    /// Used for text on [ElevatedButton], [TextButton] and [OutlinedButton].
    button: BamTextStyles.button,

    /// The smallest style.
    ///
    /// Typically used for captions or to introduce a (larger) headline.
    overline: BamTextStyles.label,
  );
}

class BamTextStyles {
  BamTextStyles._();

  static const headline1 = TextStyle(
    fontFamily: 'Rotobo',
    fontStyle: FontStyle.normal,
    color: BamColorPalette.bamBlack,
    fontSize: 27,
    height: 1.296,
  );
  static const headline2 = TextStyle(
    fontFamily: 'Rotobo',
    fontStyle: FontStyle.normal,
    color: BamColorPalette.bamBlack,
    fontSize: 24,
    height: 1.416,
  );

  static const headline3 = TextStyle(
    fontFamily: 'Rotobo',
    fontStyle: FontStyle.normal,
    color: BamColorPalette.bamBlack,
    fontSize: 21,
    height: 1.333,
  );

  static const headline4 = TextStyle(
    fontFamily: 'Rotobo',
    fontStyle: FontStyle.normal,
    color: BamColorPalette.bamBlack,
    fontSize: 16,
    height: 1.375,
  );

  static const headline5 = TextStyle(
    fontFamily: 'Rotobo',
    fontStyle: FontStyle.normal,
    color: BamColorPalette.bamBlack,
    fontSize: 36,
    height: 1.166,
  );

  static const headline6 = TextStyle(
    fontFamily: 'Rotobo',
    fontStyle: FontStyle.normal,
    color: BamColorPalette.bamBlack,
    fontSize: 18,
    letterSpacing: 0.65,
    height: 1.5,
  );

  static const bottomTabBar = TextStyle(
    fontFamily: 'Rotobo',
    fontStyle: FontStyle.normal,
    color: BamColorPalette.bamBlack,
    fontSize: 11,
  );

  static const subtitle1 = TextStyle(
    fontFamily: 'Rotobo',
    fontStyle: FontStyle.normal,
    color: BamColorPalette.bamBlack,
    fontSize: 21,
    height: 1.333,
  );

  static const body1 = TextStyle(
    fontFamily: 'Rotobo',
    fontStyle: FontStyle.normal,
    color: BamColorPalette.bamBlack,
    fontSize: 21,
    height: 1.333,
  );

  static const label = TextStyle(
    fontFamily: 'Rotobo',
    fontStyle: FontStyle.normal,
    color: BamColorPalette.bamBlack,
    fontSize: 18,
    height: 1.333,
  );

  static const subtitle2 = TextStyle(
    fontFamily: 'Rotobo',
    fontStyle: FontStyle.normal,
    color: BamColorPalette.bamBlack,
    fontSize: 15,
    height: 1.2,
  );

  static const body2 = TextStyle(
    fontFamily: 'Rotobo',
    fontStyle: FontStyle.normal,
    color: BamColorPalette.bamBlack,
    fontSize: 18,
    height: 1.333,
  );

  static const enumeration = TextStyle(
    fontFamily: 'Rotobo',
    fontStyle: FontStyle.normal,
    color: BamColorPalette.bamBlack,
    fontSize: 18,
    height: 1.333,
  );

  static const body3List = TextStyle(
    fontFamily: 'Rotobo',
    fontStyle: FontStyle.normal,
    color: BamColorPalette.bamBlack,
    fontSize: 16,
    height: 1.5,
  );

  static const subtitle3 = TextStyle(
    fontFamily: 'Rotobo',
    fontStyle: FontStyle.normal,
    color: BamColorPalette.bamBlack,
    fontSize: 14,
    height: 1.428,
  );

  static const caption = TextStyle(
    fontFamily: 'Rotobo',
    fontStyle: FontStyle.normal,
    color: BamColorPalette.bamBlack,
    fontSize: 12,
    height: 1.833,
  );

  static const button = TextStyle(
    fontFamily: 'Rotobo',
    fontStyle: FontStyle.normal,
    fontWeight: FontWeight.w500,
    color: BamColorPalette.bamBlack,
    fontSize: 18,
    letterSpacing: 0.54,
  );

  static const buttonSpecial = TextStyle(
    fontFamily: 'Rotobo',
    fontStyle: FontStyle.normal,
    fontWeight: FontWeight.w500,
    color: BamColorPalette.bamBlack,
    fontSize: 12,
    letterSpacing: 0.54,
  );

  static const buttonTop = TextStyle(
    fontFamily: 'Rotobo',
    fontStyle: FontStyle.normal,
    color: BamColorPalette.bamBlack,
    fontSize: 16,
    height: 1.375,
  );
}
