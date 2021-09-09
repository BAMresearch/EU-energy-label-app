/* * Copyright 2020 Bundesanstalt für Materialforschung und -prüfung (BAM) *
* Licensed under the EUPL, Version 1.2 or – as soon they will be approved by the European Commission - subsequent versions of the EUPL (the "Licence");
* You may not use this work except in compliance with theLicence.
* You may obtain a copy of the Licence at:
* * https://joinup.ec.europa.eu/software/page/eupl *
* Unless required by applicable law or agreed to in writing, software distributed under the Licence is distributed on an "AS IS" basis,
* WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
* See the Licence for the specific language governing permissions and limitations under the Licence.*/

import 'package:flutter/material.dart';

class BamColorPalette {
  BamColorPalette._();

  static const Color bamWhite = Color(0xFFFFFFFF);
  static const Color bamWhite40 = Color(0x66ffffff);
  static const Color bamWhite80 = Color(0xccFFFFFF);
  static const Color bamWhite20 = Color(0x33FFFFFF);

  static const Color bamBlack = Color(0xFF002832);
  static const Color bamBlack10 = Color(0xFFE6EBEE);
  static const Color bamBlack10Intensity50 = Color(0xFFf0f3f5);
  static const Color bamBlack15 = Color(0xFFCCD8DF);
  static const Color bamBlack30 = Color(0xFFA3B8C3);
  static const Color bamBlack30Optimized = Color(0xFFB1BFC6);
  static const Color bamBlack45Optimized = Color(0xFF8E9FA9);
  static const Color bamBlack60Optimized = Color(0xFF6C7F89);
  static const Color bamBlack80 = Color(0xFF325463);

  static const Color bamLightGrey = Color(0xffd3dfe9);
  static const Color bamGradientGrey = Color(0xFFE3EBF0);
  static const Color bamGradientLightGrey = Color(0xfff4f7f9);
  static const Color bamGradientVeryLightGrey = Color(0xfff6f8fa);

  static const Color bamYellow1 = Color(0xFFFFDE02);
  static const Color bamYellow2 = Color(0xFFFAB70D);
  static const Color bamYellow3 = Color(0xFFE29718);
  static const Color bamYellow4 = Color(0xFFCC7A17);

  static const Color bamRed1 = Color(0xFFD2001E);
  static const Color bamRed2 = Color(0xFFB62025);
  static const Color bamRed3 = Color(0xFF871517);
  static const Color bamRed4 = Color(0xFF4A1012);

  static const Color bamGreen1 = Color(0xFF8CBE3C);
  static const Color bamGreen2 = Color(0xFF72A442);
  static const Color bamGreen3 = Color(0xFF4F903D);
  static const Color bamGreen4 = Color(0xFF2C7C3A);

  static const Color bamBlue1 = Color(0xFF00AFF0);
  static const Color bamBlue1Variant = Color(0xff199EE3);
  static const Color bamBlue1Optimized = Color(0xFF189CD3);
  static const Color bamBlue2 = Color(0xFF048FBF);
  static const Color bamBlue2Optimized = Color(0xFF0089BB);
  static const Color bamBlue3 = Color(0xFF03769B);
  static const Color bamBlue4 = Color(0xFF015167);

  static const LinearGradient bamGrayGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.topRight,
    colors: [Color(0xFFB8CADC), bamGradientGrey],
  );

  static const LinearGradient bamSplashGrayGradient = LinearGradient(
    begin: Alignment.bottomLeft,
    end: Alignment.topRight,
    colors: [Color(0xFF99AFC0), Color(0xFFB8CADC), bamGradientGrey, bamGradientGrey],
  );

  static const LinearGradient bamLightAdviserGrayGradient = LinearGradient(
    begin: Alignment.topCenter,
    colors: [Color(0xFFB8CADC), bamGradientGrey],
  );
}

class BamColorScheme {
  BamColorScheme._();

  static final ColorScheme colorScheme = ColorScheme(
    brightness: Brightness.light,

    // Backgrounds
    background: BamColorPalette.bamBlack10Intensity50,
    onBackground: BamColorPalette.bamBlack,
    surface: Colors.white,
    onSurface: BamColorPalette.bamBlack,

    // e.g. AppBar Background Color
    primary: BamColorPalette.bamBlack,
    onPrimary: BamColorPalette.bamWhite,
    primaryVariant: BamColorPalette.bamBlack,

    // Accent color (CTA buttons, etc.)
    secondary: BamColorPalette.bamBlue1,
    onSecondary: Colors.white,
    secondaryVariant: BamColorPalette.bamBlue2,

    // Errors
    error: BamColorPalette.bamRed1,
    onError: Colors.white,
  );
}
