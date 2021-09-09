/* * Copyright 2020 Bundesanstalt für Materialforschung und -prüfung (BAM) *
* Licensed under the EUPL, Version 1.2 or – as soon they will be approved by the European Commission - subsequent versions of the EUPL (the "Licence");
* You may not use this work except in compliance with theLicence.
* You may obtain a copy of the Licence at:
* * https://joinup.ec.europa.eu/software/page/eupl *
* Unless required by applicable law or agreed to in writing, software distributed under the Licence is distributed on an "AS IS" basis,
* WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
* See the Licence for the specific language governing permissions and limitations under the Licence.*/

import 'package:energielabel_app/ui/misc/theme/bam_text_theme.dart';
import 'package:energielabel_app/utils/color_extensions.dart';
import 'package:flutter/material.dart';

class CategoryHeader extends StatelessWidget {
  const CategoryHeader({
    required this.title,
    required this.backgroundColorHex,
    required this.titleColorHex,
    required this.image,
  });

  final String backgroundColorHex;
  final String title;
  final String titleColorHex;
  final String image;

  @override
  Widget build(BuildContext context) {
    return MergeSemantics(
      child: AspectRatio(
        aspectRatio: 375 / 162,
        child: ColoredBox(
          color: ColorExtensions.fromHex(backgroundColorHex),
          child: Stack(
            children: [
              FractionallySizedBox(
                widthFactor: 1 / 2,
                child: Padding(
                  padding: const EdgeInsets.only(left: 16, top: 16),
                  child: Text(title,
                      softWrap: true,
                      style: BamTextTheme.textTheme.headline2!.copyWith(color: ColorExtensions.fromHex(titleColorHex))),
                ),
              ),
              Align(
                alignment: Alignment.bottomRight,
                child: FractionallySizedBox(
                  widthFactor: 1 / 2,
                  child: Image.asset(
                    image,
                    alignment: Alignment.bottomCenter,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
