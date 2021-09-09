/* * Copyright 2020 Bundesanstalt für Materialforschung und -prüfung (BAM) *
* Licensed under the EUPL, Version 1.2 or – as soon they will be approved by the European Commission - subsequent versions of the EUPL (the "Licence");
* You may not use this work except in compliance with theLicence.
* You may obtain a copy of the Licence at:
* * https://joinup.ec.europa.eu/software/page/eupl *
* Unless required by applicable law or agreed to in writing, software distributed under the Licence is distributed on an "AS IS" basis,
* WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
* See the Licence for the specific language governing permissions and limitations under the Licence.*/

import 'package:energielabel_app/data/asset_paths.dart';
import 'package:energielabel_app/service_locator.dart';
import 'package:energielabel_app/ui/misc/pages/base_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/translations.dart';
import 'package:package_info/package_info.dart';

import 'components/about.dart' as components;

class AppLicensePage extends StatelessWidget with BasePage {
  final PackageInfo? packageInfo = ServiceLocator().get<PackageInfo>();

  @override
  Widget build(BuildContext context) {
    return components.LicensePage(
      applicationVersion: Translations.of(context)!.about_dialog_version(packageInfo!.version, packageInfo!.buildNumber),
      applicationName: packageInfo!.appName,
      applicationIcon: Padding(
        padding: const EdgeInsets.all(24),
        child: Image.asset(
          AssetPaths.appIconImage,
          width: 100,
        ),
      ),
    );
  }
}
