/* * Copyright 2020 Bundesanstalt für Materialforschung und -prüfung (BAM) *
* Licensed under the EUPL, Version 1.2 or – as soon they will be approved by the European Commission - subsequent versions of the EUPL (the "Licence");
* You may not use this work except in compliance with theLicence.
* You may obtain a copy of the Licence at:
* * https://joinup.ec.europa.eu/software/page/eupl *
* Unless required by applicable law or agreed to in writing, software distributed under the Licence is distributed on an "AS IS" basis,
* WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
* See the Licence for the specific language governing permissions and limitations under the Licence.*/

import 'package:drop_cap_text/drop_cap_text.dart';
import 'package:energielabel_app/data/asset_paths.dart';
import 'package:energielabel_app/ui/misc/html_utils.dart';
import 'package:energielabel_app/ui/misc/theme/bam_colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class GeneralInformationWidget extends StatelessWidget {
  const GeneralInformationWidget({
    Key? key,
    this.informationTitle,
    required this.informationText,
  }) : super(key: key);

  final String? informationTitle;
  final String informationText;

  @override
  Widget build(BuildContext context) {
    return MergeSemantics(
      child: DecoratedBox(
        decoration: BoxDecoration(
          color: BamColorPalette.bamWhite,
          borderRadius: BorderRadius.circular(8),
          border: Border.all(width: 2, color: BamColorPalette.bamYellow2),
        ),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: informationTitle != null
              ? Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    // Header
                    Row(
                      children: [
                        SvgPicture.asset(
                          AssetPaths.knowHowLightBulbIcon,
                          color: BamColorPalette.bamYellow3,
                          excludeFromSemantics: true,
                        ),
                        const SizedBox(width: 20),
                        Expanded(
                          child: Text(
                            informationTitle!,
                            style: Theme.of(context).textTheme.headline3!.copyWith(color: BamColorPalette.bamYellow3),
                          ),
                        ),
                      ],
                    ),

                    const SizedBox(height: 16),

                    // Content
                    // TODO Add more spacing between bullets and make bullets smaller
                    HtmlUtils.stringToHtml(context, informationText),
                  ],
                )
              : DropCapText(
                  informationText,
                  style: Theme.of(context).textTheme.bodyText2,
                  dropCapPadding: const EdgeInsets.only(right: 14, bottom: 12, top: 4),
                  dropCap: DropCap(
                    width: 16,
                    height: 22,
                    child: SvgPicture.asset(
                      AssetPaths.knowHowLightBulbIcon,
                      color: BamColorPalette.bamYellow3,
                    ),
                  ),
                ),
        ),
      ),
    );
  }
}
