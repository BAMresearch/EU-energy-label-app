/* * Copyright 2020 Bundesanstalt für Materialforschung und -prüfung (BAM) *
* Licensed under the EUPL, Version 1.2 or – as soon they will be approved by the European Commission - subsequent versions of the EUPL (the "Licence");
* You may not use this work except in compliance with theLicence.
* You may obtain a copy of the Licence at:
* * https://joinup.ec.europa.eu/software/page/eupl *
* Unless required by applicable law or agreed to in writing, software distributed under the Licence is distributed on an "AS IS" basis,
* WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
* See the Licence for the specific language governing permissions and limitations under the Licence.*/

import 'package:energielabel_app/model/know_how/label_guide/label_category.dart';
import 'package:energielabel_app/ui/know_how/pages/label_guide/category_light_adviser_info_view_model.dart';
import 'package:energielabel_app/ui/know_how/pages/label_guide/category_light_adviser_view_model.dart';
import 'package:energielabel_app/ui/misc/page_scaffold.dart';
import 'package:energielabel_app/ui/misc/pages/base_page.dart';
import 'package:energielabel_app/ui/misc/theme/bam_colors.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

typedef BuildListCallback = List<Widget> Function(BottomSheetData bottomSheetData, BuildContext context,
    {CategoryLightAdviserViewModel viewModel, Color dividerColor});

class CategoryLightAdviserInfoPageArguments {
  const CategoryLightAdviserInfoPageArguments({required this.labelCategory, required this.buildListCallback});

  final BuildListCallback buildListCallback;
  final LabelCategory labelCategory;
}

class CategoryLightAdviserInfoPage extends StatelessPage<CategoryLightAdviserInfoViewModel> {
  CategoryLightAdviserInfoPage({Key? key, required CategoryLightAdviserInfoPageArguments initialArguments})
      : _labelCategory = initialArguments.labelCategory,
        _buildListCallback = initialArguments.buildListCallback,
        super(key: key);

  final BuildListCallback _buildListCallback;
  final LabelCategory _labelCategory;

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<CategoryLightAdviserInfoViewModel>(
      create: (context) => createViewModel(context)..onViewStarted(),
      child: PageScaffold(
        title: _labelCategory.lightAdviser!.title,
        body: _buildBody(context),
      ),
    );
  }

  Widget _buildBody(BuildContext context) {
    return Scrollbar(
      child: SingleChildScrollView(
        physics: const ClampingScrollPhysics(),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 16),
              Text(
                _labelCategory.lightAdviser!.infoSection.topText,
                style: Theme.of(context).textTheme.bodyText2!.copyWith(color: BamColorPalette.bamBlack80),
              ),
              const SizedBox(height: 32),
              Text(
                _labelCategory.lightAdviser!.infoSection.middleTitle,
                style: Theme.of(context).textTheme.headline1!.copyWith(color: BamColorPalette.bamBlue3),
              ),
              Text(
                _labelCategory.lightAdviser!.infoSection.middleText,
                style: Theme.of(context).textTheme.bodyText2!.copyWith(color: BamColorPalette.bamBlack80),
              ),
              const SizedBox(height: 16),
              DecoratedBox(
                decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(8)),
                child: Column(
                  children: _buildListCallback(BottomSheetData.brightnessLevels, context,
                      dividerColor: BamColorPalette.bamBlack10),
                ),
              ),
              const SizedBox(height: 32),
              Text(
                _labelCategory.lightAdviser!.infoSection.bottomTitle,
                style: Theme.of(context).textTheme.headline1!.copyWith(color: BamColorPalette.bamBlue3),
              ),
              Text(
                _labelCategory.lightAdviser!.infoSection.bottomText,
                style: Theme.of(context).textTheme.bodyText2!.copyWith(color: BamColorPalette.bamBlack80),
              ),
              const SizedBox(height: 16),
              DecoratedBox(
                decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(8)),
                child: Column(
                  children: _buildListCallback(BottomSheetData.colorTemperature, context,
                      dividerColor: BamColorPalette.bamBlack10),
                ),
              ),
              const SizedBox(height: 16),
            ],
          ),
        ),
      ),
    );
  }

  @override
  CategoryLightAdviserInfoViewModel createViewModel(BuildContext context) {
    return CategoryLightAdviserInfoViewModel();
  }
}
