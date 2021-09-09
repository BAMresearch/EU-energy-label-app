/* * Copyright 2020 Bundesanstalt für Materialforschung und -prüfung (BAM) *
* Licensed under the EUPL, Version 1.2 or – as soon they will be approved by the European Commission - subsequent versions of the EUPL (the "Licence");
* You may not use this work except in compliance with theLicence.
* You may obtain a copy of the Licence at:
* * https://joinup.ec.europa.eu/software/page/eupl *
* Unless required by applicable law or agreed to in writing, software distributed under the Licence is distributed on an "AS IS" basis,
* WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
* See the Licence for the specific language governing permissions and limitations under the Licence.*/

import 'package:energielabel_app/data/asset_paths.dart';
import 'package:energielabel_app/model/know_how/regulations/regulation.dart';
import 'package:energielabel_app/ui/know_how/pages/regulations/regulations_view_model.dart';
import 'package:energielabel_app/ui/misc/theme/bam_colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/translations.dart';
import 'package:flutter_svg/flutter_svg.dart';

class RegulationsCardView extends StatelessWidget {
  const RegulationsCardView({required this.regulation, this.viewModel});
  final Regulation regulation;
  final RegulationsViewModel? viewModel;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
      padding: EdgeInsets.all(8),
      decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.all(Radius.circular(8))),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          MergeSemantics(
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 16, vertical: 4),
              child: Text(
                regulation.title!,
                style: Theme.of(context).textTheme.headline4!.copyWith(color: BamColorPalette.bamBlue3),
              ),
            ),
          ),
          Divider(),
          TextButton(
            onPressed: () => viewModel!.onRegulationSelected(regulation),
            child: Row(
              children: [
                SvgPicture.asset(
                  AssetPaths.knowHowRegulationsPDFIcon,
                  color: BamColorPalette.bamBlue1,
                  fit: BoxFit.fill,
                ),
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.only(left: 8),
                    child: Text(
                      Translations.of(context)!.regulations_page_pdf_label,
                      style: Theme.of(context).textTheme.bodyText2!.copyWith(color: BamColorPalette.bamBlue1),
                    ),
                  ),
                )
              ],
            ),
          )
        ],
      ),
    );
  }
}
