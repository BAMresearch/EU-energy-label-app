/* * Copyright 2020 Bundesanstalt für Materialforschung und -prüfung (BAM) *
* Licensed under the EUPL, Version 1.2 or – as soon they will be approved by the European Commission - subsequent versions of the EUPL (the "Licence");
* You may not use this work except in compliance with theLicence.
* You may obtain a copy of the Licence at:
* * https://joinup.ec.europa.eu/software/page/eupl *
* Unless required by applicable law or agreed to in writing, software distributed under the Licence is distributed on an "AS IS" basis,
* WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
* See the Licence for the specific language governing permissions and limitations under the Licence.*/

import 'package:energielabel_app/data/asset_paths.dart';
import 'package:energielabel_app/data/favorite_repository.dart';
import 'package:energielabel_app/data/label_guide_repository.dart';
import 'package:energielabel_app/model/know_how/label_guide/label_category.dart';
import 'package:energielabel_app/model/know_how/label_guide/label_category_checklist.dart';
import 'package:energielabel_app/model/know_how/label_guide/label_category_checklist_data.dart';
import 'package:energielabel_app/service_locator.dart';
import 'package:energielabel_app/ui/know_how/components/category_header.dart';
import 'package:energielabel_app/ui/know_how/components/label_guide/general_information_widget.dart';
import 'package:energielabel_app/ui/know_how/favorite_action_listener.dart';
import 'package:energielabel_app/ui/know_how/pages/label_guide/category_checklists_view_model.dart';
import 'package:energielabel_app/ui/misc/components/bam_radio_list_tile.dart';
import 'package:energielabel_app/ui/misc/page_scaffold.dart';
import 'package:energielabel_app/ui/misc/pages/base_page.dart';
import 'package:energielabel_app/ui/misc/theme/bam_colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/translations.dart';
import 'package:provider/provider.dart';

class CategoryChecklistPageArguments {
  CategoryChecklistPageArguments({required this.labelCategory});

  final LabelCategory labelCategory;
}

class CategoryChecklistsPage extends StatelessPage<CategoryChecklistsViewModel> {
  CategoryChecklistsPage({Key? key, required CategoryChecklistPageArguments categoryChecklistPageArguments})
      : _labelCategoryChecklistData = categoryChecklistPageArguments.labelCategory.checklistData,
        _labelCategory = categoryChecklistPageArguments.labelCategory,
        super(key: key);

  final LabelCategoryChecklistData? _labelCategoryChecklistData;
  final LabelCategory _labelCategory;

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<CategoryChecklistsViewModel>(
      create: (context) => createViewModel(context)..onViewStarted(),
      child: Consumer<CategoryChecklistsViewModel>(builder: (context, viewModel, _) {
        return PageScaffold(
          title: Translations.of(context)!.checklist_page_title,
          actions: [
            IconButton(
              icon: Icon(
                viewModel.isFavorite ? Icons.star : Icons.star_border,
                color: BamColorPalette.bamBlack,
                semanticLabel: viewModel.isFavorite
                    ? Translations.of(context)!.checklists_remove_favorite_icon_semantics
                    : Translations.of(context)!.checklists_add_favorite_icon_semantics,
              ),
              onPressed: viewModel.onFavoriteButtonTapped,
            )
          ],
          body: Scrollbar(
            child: SingleChildScrollView(
              physics: const ClampingScrollPhysics(), //prevents scroll bouncing
              child: Column(
                children: [
                  _buildHeader(viewModel),
                  Padding(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        const SizedBox(height: 16),
                        _buildIntroText(viewModel.description!, context),
                        const SizedBox(height: 32),
                        _buildChecklistsSection(context, viewModel),
                        const SizedBox(height: 16),
                        GeneralInformationWidget(
                          informationTitle: viewModel.informationTitle,
                          informationText: viewModel.informationText!,
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      }),
    );
  }

  @override
  CategoryChecklistsViewModel createViewModel(BuildContext context) {
    return CategoryChecklistsViewModel(
      labelGuideRepository: ServiceLocator().get<LabelGuideRepository>()!,
      labelCategoryChecklistData: _labelCategoryChecklistData!,
      labelCategory: _labelCategory,
      favoriteRepository: ServiceLocator().get<FavoriteRepository>()!,
      favoriteActionListener: _FavoriteActionListener(context: context),
    );
  }

  Widget _buildHeader(CategoryChecklistsViewModel viewModel) {
    return CategoryHeader(
      backgroundColorHex: viewModel.headerBackgroundColorHex!,
      titleColorHex: viewModel.headerTextColorHex!,
      title: viewModel.title!,
      image: AssetPaths.labelGuideCategoryImage(viewModel.graphicPath),
    );
  }

  Widget _buildIntroText(String description, BuildContext context) {
    return Text(
      description,
      style: Theme.of(context).textTheme.bodyText2!.copyWith(color: BamColorPalette.bamBlack),
    );
  }

  Widget _buildChecklistsSection(BuildContext context, CategoryChecklistsViewModel viewModel) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(8),
      child: ColoredBox(
        color: Colors.white,
        child: Column(
          children: viewModel.checklists!
              .map((checklist) =>
                  _buildChecklistWidget(context, viewModel, checklist, checklist == viewModel.checklists!.last))
              .toList(),
        ),
      ),
    );
  }

  Widget _buildChecklistWidget(
      BuildContext context, CategoryChecklistsViewModel viewModel, LabelCategoryChecklist checklist, bool isLast) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        // Header
        Padding(
          padding: const EdgeInsets.fromLTRB(18, 16, 18, 4),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Text(
                  checklist.title!,
                  style: Theme.of(context).textTheme.headline3!.copyWith(color: BamColorPalette.bamBlue3),
                ),
              ),
            ],
          ),
        ),

        // Content
        Padding(
          padding: const EdgeInsets.only(left: 16, right: 16),
          child: Column(
            children: checklist.checklistEntries!
                .map(
                  (checklistEntry) => BamRadioListTile(
                    title: Text(
                      checklistEntry.text!,
                      style: Theme.of(context).textTheme.bodyText2!.copyWith(color: BamColorPalette.bamBlue4),
                    ),
                    value: checklistEntry.checked!,
                    onChanged: (checked) => viewModel.onChecklistEntryTapped(checked, checklistEntry, checklist),
                  ),
                )
                .toList(),
          ),
        ),
        if (!isLast)
          const Padding(
            padding: EdgeInsets.only(top: 16, bottom: 0),
            child: Divider(),
          )
        else
          const SizedBox(height: 16)
      ],
    );
  }
}

class _FavoriteActionListener extends FavoriteActionListener {
  _FavoriteActionListener({required this.context});

  final BuildContext context;

  @override
  void onAddFavoriteSuccess() {
    ScaffoldMessenger.maybeOf(context)!.showSnackBar(
      SnackBar(content: Text(Translations.of(context)!.checklist_add_favorite_success)),
    );
  }

  @override
  void onAddFavoriteFailure() {
    ScaffoldMessenger.maybeOf(context)!.showSnackBar(
      SnackBar(content: Text(Translations.of(context)!.checklist_add_favorite_failure)),
    );
  }

  @override
  void onRemoveFavoriteSuccess() {
    ScaffoldMessenger.maybeOf(context)!.showSnackBar(
      SnackBar(content: Text(Translations.of(context)!.checklist_remove_favorite_success)),
    );
  }

  @override
  void onRemoveFavoriteFailure() {
    ScaffoldMessenger.maybeOf(context)!.showSnackBar(
      SnackBar(content: Text(Translations.of(context)!.checklist_remove_favorite_failure)),
    );
  }
}
