/* * Copyright 2020 Bundesanstalt für Materialforschung und -prüfung (BAM) *
* Licensed under the EUPL, Version 1.2 or – as soon they will be approved by the European Commission - subsequent versions of the EUPL (the "Licence");
* You may not use this work except in compliance with theLicence.
* You may obtain a copy of the Licence at:
* * https://joinup.ec.europa.eu/software/page/eupl *
* Unless required by applicable law or agreed to in writing, software distributed under the Licence is distributed on an "AS IS" basis,
* WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
* See the Licence for the specific language governing permissions and limitations under the Licence.*/

import 'package:energielabel_app/data/asset_paths.dart';
import 'package:energielabel_app/device_info.dart';
import 'package:energielabel_app/service_locator.dart';
import 'package:energielabel_app/ui/home/routing.dart';
import 'package:energielabel_app/ui/misc/components/circular_flat_button.dart';
import 'package:energielabel_app/ui/misc/theme/bam_colors.dart';
import 'package:energielabel_app/ui/misc/theme/bam_text_theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/translations.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:pedantic/pedantic.dart';
import 'package:share/share.dart';

class HomeDrawer extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ColoredBox(
        color: BamColorPalette.bamBlack80,
        child: SafeArea(
          child: Scrollbar(
            child: SingleChildScrollView(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.only(left: 16, right: 16, top: 25, bottom: 35),
                    child: MergeSemantics(
                      child: CircularFlatButton(
                        onPressed: () => _closeDrawer(context),
                        child: SvgPicture.asset(
                          AssetPaths.drawerCloseIcon,
                          semanticsLabel: Translations.of(context)!.semantic_home_dashboard_drawer_menu_close,
                        ),
                      ),
                    ),
                  ),

                  // Infothek
                  Padding(
                    padding: EdgeInsetsDirectional.only(start: 32, bottom: 12),
                    child: Text(
                      Translations.of(context)!.home_menu_infothek,
                      style: BamTextStyles.subtitle3.copyWith(color: BamColorPalette.bamYellow1),
                    ),
                  ),

                  // First steps
                  _NavItem(
                    label: Translations.of(context)!.home_menu_first_steps,
                    onTap: () => _onFirstStepsItemTapped(context),
                  ),

                  // About the app
                  _NavItem(
                    label: Translations.of(context)!.home_menu_about_app,
                    onTap: () => _onAboutAppItemTapped(context),
                  ),

                  // Privacy Policy
                  _NavItem(
                    label: Translations.of(context)!.home_menu_privacy_policy,
                    onTap: () => _onPrivacyPolicyItemTapped(context),
                  ),

                  // Imprint
                  _NavItem(
                    label: Translations.of(context)!.home_menu_imprint,
                    onTap: () => _onImprintItemTapped(context),
                  ),

                  SizedBox(height: 24),

                  // Share
                  _NavItem(
                    label: Translations.of(context)!.home_menu_share,
                    onTap: () => _onShareItemTapped(context),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  void _onFirstStepsItemTapped(BuildContext context) async {
    _closeDrawer(context);

    unawaited(
      Navigator.of(context).pushNamed(HomeRoutes.firstSteps),
    );
  }

  void _onAboutAppItemTapped(BuildContext context) async {
    _closeDrawer(context);

    unawaited(
      Navigator.of(context).pushNamed(HomeRoutes.aboutApp),
    );
  }

  Future<void> _onPrivacyPolicyItemTapped(BuildContext context) async {
    _closeDrawer(context);

    final deviceInfo = ServiceLocator().get<DeviceInfo>()!;
    final privacyPolicyAssetPath = AssetPaths.privacyPolicyHtml(deviceInfo.bestMatchedLocale);

    unawaited(
      Navigator.of(context).pushNamed(HomeRoutes.privacyPolicy, arguments: privacyPolicyAssetPath),
    );
  }

  Future<void> _onImprintItemTapped(BuildContext context) async {
    _closeDrawer(context);

    final deviceInfo = ServiceLocator().get<DeviceInfo>()!;
    final imprintAssetPath = AssetPaths.imprintHtml(deviceInfo.bestMatchedLocale);
    unawaited(
      Navigator.of(context).pushNamed(HomeRoutes.imprint, arguments: imprintAssetPath),
    );
  }

  void _onShareItemTapped(BuildContext context) {
    _closeDrawer(context);

    Share.share(
      Translations.of(context)!.share_page_body,
      subject: Translations.of(context)!.share_page_subject,
    );
  }

  void _closeDrawer(BuildContext context) {
    Navigator.of(context).pop();
  }
}

class _NavItem extends StatelessWidget {
  const _NavItem({Key? key, this.label, this.onTap}) : super(key: key);

  final String? label;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: CircularFlatButton(
        onPressed: onTap,
        padding: EdgeInsets.zero,
        child: ListTile(
          dense: true,
          title: Text(
            label!,
            style: Theme.of(context).textTheme.headline3!.copyWith(color: BamColorPalette.bamWhite80, fontSize: 20),
          ),
          contentPadding: EdgeInsetsDirectional.only(start: 16),
        ),
      ),
    );
  }
}
