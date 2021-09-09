/* * Copyright 2020 Bundesanstalt für Materialforschung und -prüfung (BAM) *
* Licensed under the EUPL, Version 1.2 or – as soon they will be approved by the European Commission - subsequent versions of the EUPL (the "Licence");
* You may not use this work except in compliance with theLicence.
* You may obtain a copy of the Licence at:
* * https://joinup.ec.europa.eu/software/page/eupl *
* Unless required by applicable law or agreed to in writing, software distributed under the Licence is distributed on an "AS IS" basis,
* WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
* See the Licence for the specific language governing permissions and limitations under the Licence.*/

import 'package:energielabel_app/data/asset_paths.dart';
import 'package:energielabel_app/ui/home/routing.dart';
import 'package:energielabel_app/ui/misc/components/item_button.dart';
import 'package:energielabel_app/ui/misc/page_scaffold.dart';
import 'package:energielabel_app/ui/misc/pages/base_page.dart';
import 'package:energielabel_app/ui/misc/theme/bam_colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_gen/gen_l10n/translations.dart';

class AboutAppPage extends StatelessWidget with BasePage {
  @override
  Widget build(BuildContext context) {
    return PageScaffold(
      title: Translations.of(context)!.home_menu_about_app,
      body: _buildBody(context),
    );
  }

  Widget _buildBody(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 34, 20, 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            Translations.of(context)!.about_app_languages,
            style: Theme.of(context).textTheme.headline2!.copyWith(color: BamColorPalette.bamBlue3),
          ),
          SizedBox(height: 16),
          Text(
            Translations.of(context)!.about_app_languages_detail,
            style: Theme.of(context).textTheme.headline4!.copyWith(color: BamColorPalette.bamBlack80),
          ),
          SizedBox(height: 32),
          ItemButton(
            label: Translations.of(context)!.about_app_licenses,
            iconAssetPath: AssetPaths.shieldIcon,
            onTap: () => _onLicenseItemSelected(context),
          )
        ],
      ),
    );
  }

  void _onLicenseItemSelected(BuildContext context) {
    Navigator.of(context).pushNamed(HomeRoutes.aboutAppLicense);
  }
}
