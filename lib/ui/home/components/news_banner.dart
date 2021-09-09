/* * Copyright 2020 Bundesanstalt für Materialforschung und -prüfung (BAM) *
* Licensed under the EUPL, Version 1.2 or – as soon they will be approved by the European Commission - subsequent versions of the EUPL (the "Licence");
* You may not use this work except in compliance with theLicence.
* You may obtain a copy of the Licence at:
* * https://joinup.ec.europa.eu/software/page/eupl *
* Unless required by applicable law or agreed to in writing, software distributed under the Licence is distributed on an "AS IS" basis,
* WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
* See the Licence for the specific language governing permissions and limitations under the Licence.*/

import 'package:energielabel_app/data/asset_paths.dart';
import 'package:energielabel_app/model/home/news.dart';
import 'package:energielabel_app/ui/misc/theme/bam_colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/translations.dart';
import 'package:flutter_svg/flutter_svg.dart';

class NewsBanner extends StatelessWidget {
  const NewsBanner({
    required this.news,
    required this.onCloseAction,
  });

  final News news;
  final VoidCallback onCloseAction;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.only(top: 20),
      decoration: BoxDecoration(gradient: BamColorPalette.bamGrayGradient),
      width: double.maxFinite,
      child: FractionallySizedBox(
        widthFactor: 336 / 375,
        child: Container(
          decoration: BoxDecoration(color: BamColorPalette.bamWhite20, borderRadius: BorderRadius.circular(8)),
          constraints: BoxConstraints(minHeight: 56),
          child: Material(
            color: Colors.transparent,
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: MergeSemantics(
                    child: Padding(
                      padding: const EdgeInsetsDirectional.fromSTEB(20, 16, 16, 20),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            news.title!,
                            style: Theme.of(context).textTheme.headline3!.copyWith(color: BamColorPalette.bamBlack),
                          ),
                          SizedBox(height: 8),
                          Text(
                            news.description!,
                            style: Theme.of(context).textTheme.bodyText2!.copyWith(
                                  color: BamColorPalette.bamBlack80,
                                ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                MergeSemantics(
                  child: IconButton(
                    icon: SvgPicture.asset(
                      AssetPaths.newsCloseIcon,
                      semanticsLabel: Translations.of(context)!.semantic_home_dashboard_close_news,
                    ),
                    onPressed: onCloseAction,
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
