/* * Copyright 2020 Bundesanstalt für Materialforschung und -prüfung (BAM) *
* Licensed under the EUPL, Version 1.2 or – as soon they will be approved by the European Commission - subsequent versions of the EUPL (the "Licence");
* You may not use this work except in compliance with theLicence.
* You may obtain a copy of the Licence at:
* * https://joinup.ec.europa.eu/software/page/eupl *
* Unless required by applicable law or agreed to in writing, software distributed under the Licence is distributed on an "AS IS" basis,
* WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
* See the Licence for the specific language governing permissions and limitations under the Licence.*/

import 'package:energielabel_app/data/asset_paths.dart';
import 'package:energielabel_app/model/know_how/label_guide/label_category.dart';
import 'package:energielabel_app/ui/know_how/components/category_header.dart';
import 'package:energielabel_app/ui/know_how/know_how_routes.dart';
import 'package:energielabel_app/ui/know_how/pages/label_guide/category_checklists_page.dart';
import 'package:energielabel_app/ui/know_how/pages/label_guide/category_guide_page.dart';
import 'package:energielabel_app/ui/know_how/pages/label_guide/category_tips_page.dart';
import 'package:energielabel_app/ui/misc/components/item_button.dart';
import 'package:energielabel_app/ui/misc/page_scaffold.dart';
import 'package:energielabel_app/ui/misc/pages/base_page.dart';
import 'package:flutter/material.dart';

import 'category_light_adviser_page.dart';

/// Page showing the details of a given [LabelCategory].
class CategoryOverviewPage extends StatelessWidget with BasePage {
  CategoryOverviewPage({required LabelCategory labelCategory}) : _labelCategory = labelCategory;

  final LabelCategory _labelCategory;

  @override
  Widget build(BuildContext context) {
    return PageScaffold(
      title: _labelCategory.productType,
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            _buildBanner(context),
            SizedBox(height: 32),
            _buildTooltip(context),
            SizedBox(height: 24),
            _buildChecklistTile(context),
            SizedBox(height: 16),
            _buildTipsTile(context),
            if (_labelCategory.guideData != null) ...[
              SizedBox(height: 16),
              _buildFridgeTile(context),
            ],
            if (_labelCategory.lightAdviser != null) ...[
              SizedBox(height: 16),
              _buildLightAdviserTile(context),
            ]
          ],
        ),
      ),
    );
  }

  Widget _buildBanner(BuildContext context) {
    return CategoryHeader(
      title: _labelCategory.productType!,
      backgroundColorHex: _labelCategory.backgroundColorHex!,
      titleColorHex: _labelCategory.textColorHex!,
      image: AssetPaths.labelGuideCategoryImage(_labelCategory.graphicPath),
    );
  }

  Widget _buildTooltip(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Text(_labelCategory.description!, style: Theme.of(context).textTheme.bodyText2),
    );
  }

  Widget _buildChecklistTile(BuildContext context) {
    return _buildTile(
      context: context,
      label: _labelCategory.checklistData!.title!,
      iconAssetPath: AssetPaths.knowHowMenuChecklistIcon,
      onTap: () => Navigator.of(context).pushNamed(
        KnowHowRoutes.labelGuideCategoryChecklists,
        arguments: CategoryChecklistPageArguments(labelCategory: _labelCategory),
      ),
    );
  }

  Widget _buildTipsTile(BuildContext context) {
    return _buildTile(
      context: context,
      label: _labelCategory.tipData!.title!,
      iconAssetPath: AssetPaths.knowHowMenuTipsIcon,
      onTap: () => Navigator.of(context).pushNamed(
        KnowHowRoutes.labelGuideTips,
        arguments: CategoryTipsPageArguments(labelCategory: _labelCategory),
      ),
    );
  }

  Widget _buildFridgeTile(BuildContext context) {
    return _buildTile(
      context: context,
      label: _labelCategory.guideData!.title!,
      iconAssetPath: AssetPaths.knowHowMenuFridgeGuideIcon,
      onTap: () => Navigator.of(context).pushNamed(
        KnowHowRoutes.labelGuideCategoryGuide,
        arguments: CategoryGuidePageArguments(labelCategory: _labelCategory),
      ),
    );
  }

  Widget _buildLightAdviserTile(BuildContext context) {
    return _buildTile(
      context: context,
      label: _labelCategory.lightAdviser!.title!,
      iconAssetPath: AssetPaths.knowHowMenuLightAdviserIcon,
      onTap: () => Navigator.of(context).pushNamed(
        KnowHowRoutes.labelGuideCategoryLight,
        arguments: CategoryLightAdviserPageArguments(labelCategory: _labelCategory),
      ),
    );
  }

  Widget _buildTile(
      {BuildContext? context, required String label, required String iconAssetPath, required VoidCallback onTap}) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: ItemButton(label: label, iconAssetPath: iconAssetPath, onTap: onTap),
    );
  }
}
