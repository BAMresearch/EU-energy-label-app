/* * Copyright 2020 Bundesanstalt für Materialforschung und -prüfung (BAM) *
* Licensed under the EUPL, Version 1.2 or – as soon they will be approved by the European Commission - subsequent versions of the EUPL (the "Licence");
* You may not use this work except in compliance with theLicence.
* You may obtain a copy of the Licence at:
* * https://joinup.ec.europa.eu/software/page/eupl *
* Unless required by applicable law or agreed to in writing, software distributed under the Licence is distributed on an "AS IS" basis,
* WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
* See the Licence for the specific language governing permissions and limitations under the Licence.*/

import 'package:energielabel_app/data/asset_paths.dart';
import 'package:energielabel_app/ui/know_how/know_how_routes.dart';
import 'package:energielabel_app/ui/misc/components/item_button.dart';
import 'package:energielabel_app/ui/misc/components/label_guide_card.dart';
import 'package:energielabel_app/ui/misc/page_scaffold.dart';
import 'package:energielabel_app/ui/misc/pages/base_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/translations.dart';

class KnowHowPage extends StatelessWidget with BasePage {
  @override
  Widget build(BuildContext context) {
    return PageScaffold(
      hasElevation: false,
      title: Translations.of(context)!.know_how_page_title,
      body: Scrollbar(
        child: SingleChildScrollView(
          child: Align(
            alignment: Alignment.center,
            child: Column(
              children: [
                LabelGuideCard(
                    onPressed: () => Navigator.of(context).pushNamed(KnowHowRoutes.labelGuideCategoriesOverview)),
                FractionallySizedBox(
                  widthFactor: 338 / 375,
                  child: Column(
                    children: [
                      _buildDivider(),
                      ItemButton(
                        label: Translations.of(context)!.know_how_item_why_is_there,
                        iconAssetPath: AssetPaths.knowHowMenuWhyIsThereIcon,
                        onTap: () => Navigator.of(context).pushNamed(KnowHowRoutes.whyIsThere),
                      ),
                      _buildDivider(),
                      ItemButton(
                        label: Translations.of(context)!.know_how_item_glossary,
                        iconAssetPath: AssetPaths.knowHowMenuGlossaryIcon,
                        onTap: () => Navigator.of(context).pushNamed(KnowHowRoutes.glossary),
                      ),
                      _buildDivider(),
                      ItemButton(
                        label: Translations.of(context)!.know_how_item_regulations,
                        iconAssetPath: AssetPaths.knowHowMenuRegulationsIcon,
                        onTap: () => Navigator.of(context).pushNamed(KnowHowRoutes.regulations),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildDivider() {
    return SizedBox(height: 16);
  }
}
