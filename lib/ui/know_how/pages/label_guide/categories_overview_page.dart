/* * Copyright 2020 Bundesanstalt für Materialforschung und -prüfung (BAM) *
* Licensed under the EUPL, Version 1.2 or – as soon they will be approved by the European Commission - subsequent versions of the EUPL (the "Licence");
* You may not use this work except in compliance with theLicence.
* You may obtain a copy of the Licence at:
* * https://joinup.ec.europa.eu/software/page/eupl *
* Unless required by applicable law or agreed to in writing, software distributed under the Licence is distributed on an "AS IS" basis,
* WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
* See the Licence for the specific language governing permissions and limitations under the Licence.*/

import 'package:energielabel_app/data/asset_paths.dart';
import 'package:energielabel_app/data/label_guide_repository.dart';
import 'package:energielabel_app/model/know_how/label_guide/label_category.dart';
import 'package:energielabel_app/service_locator.dart';
import 'package:energielabel_app/ui/know_how/pages/label_guide/categories_overview_view_model.dart';
import 'package:energielabel_app/ui/misc/page_scaffold.dart';
import 'package:energielabel_app/ui/misc/pages/base_page.dart';
import 'package:energielabel_app/ui/misc/theme/bam_colors.dart';
import 'package:energielabel_app/utils/color_extensions.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:responsive_layout_builder/responsive_layout_builder.dart';

class CategoriesOverviewPage extends StatelessPage<CategoriesOverviewViewModel> {
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<CategoriesOverviewViewModel>(
      create: (context) => createViewModel(context)..onViewStarted(),
      child: Consumer<CategoriesOverviewViewModel>(
        builder: (context, viewModel, _) {
          return PageScaffold(
            title: viewModel.title,
            body: ResponsiveLayoutBuilder(
              builder: (context, layoutSize) {
                switch (layoutSize.size) {
                  case LayoutSize.mobile:
                    return _buildMobileLayout(context, viewModel);
                    break;
                  case LayoutSize.tablet:
                  case LayoutSize.desktop:
                    return _buildTabletLayout(context, viewModel);
                    break;
                  default:
                    throw ArgumentError('ScreenSize not supported: ${layoutSize.size}');
                }
              },
            ),
          );
        },
      ),
    );
  }

  Widget _buildMobileLayout(BuildContext context, CategoriesOverviewViewModel viewModel) {
    return ListView.builder(
      padding: const EdgeInsets.symmetric(vertical: 16),
      itemCount: viewModel.labelCategories.length,
      itemBuilder: (BuildContext context, int index) => _listItemAtIndex(context, index, viewModel),
    );
  }

  Widget _buildTabletLayout(BuildContext context, CategoriesOverviewViewModel viewModel) {
    return GridView.builder(
      padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 32),
      gridDelegate:
          SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 2, childAspectRatio: 1.9, mainAxisSpacing: 16),
      itemCount: viewModel.labelCategories.length,
      itemBuilder: (context, index) => _listItemAtIndex(context, index, viewModel),
    );
  }

  @override
  CategoriesOverviewViewModel createViewModel(BuildContext context) {
    return CategoriesOverviewViewModel(
      context: context,
      labelGuideRepository: ServiceLocator().get<LabelGuideRepository>(),
    );
  }

  Widget _listItemAtIndex(BuildContext context, int index, CategoriesOverviewViewModel viewModel) {
    final LabelCategory labelCategory = viewModel.labelCategories[index];

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: AspectRatio(
        aspectRatio: 339 / 122,
        child: GestureDetector(
          onTap: () => viewModel.onCategoryTapped(labelCategory),
          child: Container(
            clipBehavior: Clip.antiAlias,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(8),
              color: ColorExtensions.fromHex(labelCategory.backgroundColorHex),
            ),
            child: Row(
              children: [
                Expanded(
                  flex: 6,
                  child: Align(
                    alignment: Alignment.topLeft,
                    child: Padding(
                      padding: const EdgeInsets.all(19.0),
                      child: Text(
                        labelCategory.productType,
                        style: Theme.of(context)
                            .textTheme
                            .headline3
                            .copyWith(color: ColorExtensions.fromHex(labelCategory.textColorHex)),
                      ),
                    ),
                  ),
                ),
                Expanded(
                  flex: 4,
                  child: Align(
                    alignment: Alignment.bottomCenter,
                    child: Image.asset(
                      AssetPaths.labelGuideCategoryImage(labelCategory.graphicPath),
                      errorBuilder: (context, error, stacktrace) => Align(
                        alignment: Alignment.center,
                        child: Opacity(
                          opacity: 0.5,
                          child: Icon(
                            Icons.image_not_supported_outlined,
                            color: BamColorPalette.bamWhite,
                            size: 32,
                          ),
                        ),
                      ),
                    ),
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
