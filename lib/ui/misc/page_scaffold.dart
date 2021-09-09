/* * Copyright 2020 Bundesanstalt für Materialforschung und -prüfung (BAM) *
* Licensed under the EUPL, Version 1.2 or – as soon they will be approved by the European Commission - subsequent versions of the EUPL (the "Licence");
* You may not use this work except in compliance with theLicence.
* You may obtain a copy of the Licence at:
* * https://joinup.ec.europa.eu/software/page/eupl *
* Unless required by applicable law or agreed to in writing, software distributed under the Licence is distributed on an "AS IS" basis,
* WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
* See the Licence for the specific language governing permissions and limitations under the Licence.*/

import 'package:auto_size_text/auto_size_text.dart';
import 'package:energielabel_app/ui/misc/theme/bam_colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/translations.dart';
import 'package:flutter_svg/flutter_svg.dart';

class PageScaffold extends StatelessWidget {
  PageScaffold({
    this.title,
    this.drawer,
    this.drawerIcon,
    this.appBarLeading,
    this.automaticallyImplyLeading = true,
    this.customAppBarContent,
    this.actions,
    this.hasElevation = true,
    required this.body,
    this.titleSemanticLabel,
  });

  final String? title;
  final String? titleSemanticLabel;
  final Widget? drawer;
  final Widget? appBarLeading;
  final bool automaticallyImplyLeading;
  final bool hasElevation;
  final String? drawerIcon;
  final Widget? customAppBarContent;
  final List<Widget>? actions;
  final Widget body;

  @override
  Widget build(BuildContext context) {
    final bool isSubTabScreen = Navigator.of(context).canPop();

    return Scaffold(
      appBar: AppBar(
        flexibleSpace: Container(decoration: BoxDecoration(gradient: BamColorPalette.bamGrayGradient)),
        centerTitle: isSubTabScreen ? null : false,
        // When setting the height to 140, Flutter will not draw the elements correctly,
        // but introduce a horizontal line on some devices, e. g. Nexus 5X. There appear to be some
        // sweet spots with increasing height values. 138 is the nearest to 140, that doesn't draw a line on other
        // devices, e. g. 141 will draw a line on Pixel 3 XL.
        toolbarHeight: isSubTabScreen ? kToolbarHeight : 138,
        elevation: hasElevation ? 4 : 0,
        title: customAppBarContent ??
            (title != null
                ? isSubTabScreen
                    ? AutoSizeText(
                        title!.toUpperCase(),
                        style: Theme.of(context).textTheme.headline6!.copyWith(color: BamColorPalette.bamBlack),
                        semanticsLabel: titleSemanticLabel,
                      )
                    : Text(
                        title!,
                        maxLines: 2,
                        style: Theme.of(context).textTheme.headline5!.copyWith(color: BamColorPalette.bamBlack),
                        semanticsLabel: titleSemanticLabel,
                      )
                : null),
        leading: drawer != null && drawerIcon != null
            ? Builder(
                builder: (context) => MergeSemantics(
                  child: IconButton(
                    icon: SvgPicture.asset(
                      drawerIcon!,
                      semanticsLabel: Translations.of(context)!.semantic_home_dashboard_drawer_menu_open,
                    ),
                    onPressed: () => Scaffold.of(context).openDrawer(),
                  ),
                ),
              )
            : appBarLeading,
        automaticallyImplyLeading: automaticallyImplyLeading,
        actions: actions,
      ),
      body: SafeArea(child: body),
      drawer: drawer,
    );
  }
}
