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
import 'package:energielabel_app/ui/misc/theme/bam_text_theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/translations.dart';

class LabelGuideCard extends StatelessWidget {
  const LabelGuideCard({
    Key? key,
    required this.onPressed,
  }) : super(key: key);

  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    return Semantics(
      button: true,
      label: Translations.of(context)!.home_dashboard_label_guide,
      child: ExcludeSemantics(
        child: AspectRatio(
          aspectRatio: 375 / 128,
          child: Stack(
            alignment: Alignment.center,
            children: [
              Column(
                children: [
                  Expanded(
                    child: Container(
                      decoration: const BoxDecoration(gradient: BamColorPalette.bamGrayGradient),
                    ),
                  ),
                  const Expanded(child: SizedBox.shrink()),
                ],
              ),
              AspectRatio(
                aspectRatio: 336 / 128,
                child: GestureDetector(
                  onTap: onPressed,
                  child: Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(8),
                      color: BamColorPalette.bamBlue1,
                    ),
                    child: Stack(
                      children: [
                        Align(
                          alignment: Alignment.bottomRight,
                          child: Padding(
                            padding: const EdgeInsets.only(top: 16),
                            child: Image.asset(AssetPaths.labelGuideImage),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(16),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                Translations.of(context)!.home_dashboard_label_guide,
                                style: Theme.of(context).textTheme.headline3!.copyWith(color: BamColorPalette.bamWhite),
                              ),
                              Container(
                                padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 8),
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(8),
                                  color: BamColorPalette.bamBlue2Optimized,
                                ),
                                child: Text(
                                  Translations.of(context)!.home_dashboard_label_guide_hint.toUpperCase(),
                                  style: BamTextStyles.buttonSpecial.copyWith(color: BamColorPalette.bamWhite),
                                ),
                              )
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
