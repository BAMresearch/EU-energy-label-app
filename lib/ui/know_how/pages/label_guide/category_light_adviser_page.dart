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
import 'package:energielabel_app/ui/know_how/pages/label_guide/category_light_adviser_info_page.dart';
import 'package:energielabel_app/ui/know_how/pages/label_guide/category_light_adviser_view_model.dart';
import 'package:energielabel_app/ui/misc/page_scaffold.dart';
import 'package:energielabel_app/ui/misc/pages/base_page.dart';
import 'package:energielabel_app/ui/misc/theme/bam_colors.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_html/shims/dart_ui_real.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:provider/provider.dart';

class CategoryLightAdviserPageArguments {
  const CategoryLightAdviserPageArguments({required this.labelCategory});

  final LabelCategory labelCategory;
}

class CategoryLightAdviserPage extends StatelessPage<CategoryLightAdviserViewModel> {
  CategoryLightAdviserPage({required CategoryLightAdviserPageArguments initialArguments})
      : _labelCategory = initialArguments.labelCategory;

  final int _animationDuration = 300;
  final LabelCategory _labelCategory;

  @override
  CategoryLightAdviserViewModel createViewModel(BuildContext context) {
    return CategoryLightAdviserViewModel(context, _labelCategory.lightAdviser!);
  }

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<CategoryLightAdviserViewModel>(
      create: (context) => createViewModel(context)..onViewStarted(),
      child: Consumer<CategoryLightAdviserViewModel>(
        builder: (context, viewModel, _) => PageScaffold(
          title: _labelCategory.lightAdviser!.title,
          body: _buildBody(context, viewModel),
          actions: [
            IconButton(
              icon: Icon(Icons.info_outline, color: BamColorPalette.bamBlack),
              onPressed: () => viewModel.onInfoButtonTapped(CategoryLightAdviserInfoPageArguments(
                  labelCategory: _labelCategory, buildListCallback: _buildSelectionSheetEntries)),
            )
          ],
        ),
      ),
    );
  }

  Widget _buildBody(BuildContext context, CategoryLightAdviserViewModel viewModel) {
    return Container(
      height: double.maxFinite,
      decoration: BoxDecoration(
        gradient: BamColorPalette.bamLightAdviserGrayGradient,
      ),
      child: LayoutBuilder(builder: (BuildContext context, BoxConstraints constraints) {
        viewModel.bodyConstraints = constraints;
        return Stack(
          alignment: Alignment.topCenter,
          children: [
            Align(
              alignment: Alignment.bottomCenter,
              child: SvgPicture.asset(
                AssetPaths.knowHowLightAdviserBackground,
                width: constraints.maxWidth,
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Expanded(
                    child: Stack(
                      children: [
                        Container(
                          width: double.maxFinite,
                          margin: EdgeInsets.only(top: MediaQuery.of(context).size.width < 414 ? 40 : 20),
                          height: double.maxFinite,
                          child: Image.asset(
                            AssetPaths.knowHowLightAdviserIconsBasePath + viewModel.bulbImageFileName(),
                            gaplessPlayback: true,
                          ),
                        ),
                        Text(
                          _labelCategory.lightAdviser?.introText ?? '',
                          style: Theme.of(context).textTheme.bodyText2!.copyWith(color: BamColorPalette.bamBlack80),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(height: 8),
                  Column(
                    children: [
                      AnimatedOpacity(
                        duration: Duration(milliseconds: _animationDuration),
                        curve: Curves.easeInOut,
                        opacity: !viewModel.isSelectionSheetVisible ? 1 : 0,
                        child: Column(
                          children: [
                            Row(
                              children: [
                                Expanded(
                                  child: _buildInfoSheetLabel(
                                      context, _labelCategory.lightAdviser!.categoryBrightnessLabel),
                                ),
                                Expanded(
                                  child: _buildInfoSheetLabel(
                                      context, _labelCategory.lightAdviser!.categoryColorTemeratureLabel),
                                ),
                              ],
                            ),
                            Divider(color: Colors.white, height: 1),
                            Stack(
                              alignment: Alignment.topCenter,
                              children: [
                                if (viewModel.shouldShowExpansionToggleButton)
                                  IconButton(onPressed: viewModel.onExpansionToggleTap, icon: viewModel.toggleIcon),
                                _buildBottomLayout(viewModel, context, constraints.maxHeight),
                              ],
                            )
                          ],
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        );
      }),
    );
  }

  Widget _buildInfoSheetLabel(BuildContext context, String labelText) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Text(
        labelText.toUpperCase(),
        textAlign: TextAlign.center,
        style: Theme.of(context).textTheme.subtitle2!.copyWith(color: BamColorPalette.bamBlack80),
      ),
    );
  }

  Widget _buildButton(BuildContext context,
      {bool showButtonText = true,
      required BottomSheetData bottomSheetData,
      required CategoryLightAdviserViewModel viewModel,
      required double maxHeight}) {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        children: [
          DecoratedBox(
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: BamColorPalette.bamGradientVeryLightGrey,
            ),
            child: IconButton(
              padding: EdgeInsets.all(16),
              onPressed: () => !viewModel.isSelectionSheetVisible
                  ? _onTapSelectionButton(viewModel, context, bottomSheetData, maxHeight)
                  : Navigator.pop(context),
              color: BamColorPalette.bamBlue1Variant,
              icon: SvgPicture.asset(bottomSheetData == BottomSheetData.colorTemperature
                  ? AssetPaths.knowHowLightAdviserTemperatureRoomIcon
                  : AssetPaths.knowHowLightAdviserBrightnessLevelIcon),
            ),
          ),
          if (showButtonText) SizedBox(height: 16),
          if (showButtonText)
            Text(
              _labelCategory.lightAdviser!.buttonLabel,
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.subtitle2!.copyWith(color: BamColorPalette.bamBlack80),
            )
        ],
      ),
    );
  }

  Widget _buildSelectionSheet(
    BuildContext context, {
    required BottomSheetData sheetCategory,
    required CategoryLightAdviserViewModel viewModel,
    required double maxHeight,
  }) {
    return Container(
      constraints: BoxConstraints(maxHeight: maxHeight),
      child: IntrinsicHeight(
        child: Column(
          mainAxisSize: MainAxisSize.max,
          children: [
            Center(
              child: Row(
                mainAxisSize: MainAxisSize.max,
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  _buildSelectionSheetTitle(
                      context, viewModel, BottomSheetData.brightnessLevels, sheetCategory, maxHeight),
                  _buildSelectionSheetTitle(
                      context, viewModel, BottomSheetData.colorTemperature, sheetCategory, maxHeight),
                ],
              ),
            ),
            Expanded(
              child: DecoratedBox(
                decoration: BoxDecoration(
                  boxShadow: [BoxShadow(spreadRadius: 1, blurRadius: 5, color: BamColorPalette.bamBlack15)],
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [BamColorPalette.bamGradientLightGrey, BamColorPalette.bamGradientGrey],
                  ),
                ),
                child: Column(
                  children: [
                    Expanded(
                      child: Scrollbar(
                        isAlwaysShown: true,
                        child: SingleChildScrollView(
                          physics: ClampingScrollPhysics(),
                          child: Column(
                            children: _buildSelectionSheetEntries(sheetCategory, context, viewModel: viewModel),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  List<Widget> _buildSelectionSheetEntries(BottomSheetData bottomSheetData, BuildContext context,
      {CategoryLightAdviserViewModel? viewModel, Color dividerColor = BamColorPalette.bamBlack15}) {
    if (bottomSheetData == BottomSheetData.brightnessLevels) {
      return _labelCategory.lightAdviser!.brightnessLevels.keys
          .map((key) => Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Material(
                    color: Colors.transparent,
                    child: InkWell(
                      onTap: viewModel == null
                          ? null
                          : () {
                              viewModel.selectedBrightnessLevel = viewModel.selectedBrightnessLevel != key ? key : null;
                              Navigator.pop(context);
                            },
                      child: ListTile(
                        selected: viewModel?.selectedBrightnessLevel == key,
                        selectedTileColor: BamColorPalette.bamWhite,
                        contentPadding: EdgeInsets.symmetric(horizontal: 32),
                        leading: SvgPicture.asset(AssetPaths.knowHowLightAdviserIconsBasePath +
                            _labelCategory.lightAdviser!.brightnessLevels[key]!.iconFileName),
                        title: Text(
                          _labelCategory.lightAdviser!.brightnessLevels[key]!.description,
                          style: Theme.of(context).textTheme.bodyText1!.copyWith(color: BamColorPalette.bamBlack80),
                        ),
                        subtitle: Text(_labelCategory.lightAdviser!.brightnessLevels[key]!.power,
                            style: Theme.of(context).textTheme.subtitle2!.copyWith(color: BamColorPalette.bamBlack80)),
                      ),
                    ),
                  ),
                  if (key != _labelCategory.lightAdviser!.brightnessLevels.keys.last)
                    Divider(color: dividerColor, indent: 16, endIndent: 16, height: 1)
                ],
              ))
          .toList();
    } else if (bottomSheetData == BottomSheetData.colorTemperature) {
      return _labelCategory.lightAdviser!.rooms.keys
          .map((key) => Column(
                children: [
                  Material(
                    color: Colors.transparent,
                    child: InkWell(
                      onTap: viewModel == null
                          ? null
                          : () {
                              viewModel.selectedRoom = viewModel.selectedRoom != key ? key : null;
                              Navigator.pop(context);
                            },
                      child: ListTile(
                        selected: viewModel?.selectedRoom == key,
                        selectedTileColor: BamColorPalette.bamWhite,
                        contentPadding: EdgeInsets.symmetric(horizontal: 32),
                        leading: SvgPicture.asset(AssetPaths.knowHowLightAdviserIconsBasePath +
                            _labelCategory.lightAdviser!.rooms[key]!.iconFileName),
                        title: Text(
                          _labelCategory.lightAdviser!.rooms[key]!.label,
                          style: Theme.of(context).textTheme.bodyText1!.copyWith(color: BamColorPalette.bamBlack80),
                        ),
                      ),
                    ),
                  ),
                  if (key != _labelCategory.lightAdviser!.rooms.keys.last)
                    Divider(color: dividerColor, indent: 16, endIndent: 16, height: 1)
                ],
              ))
          .toList();
    } else {
      return [];
    }
  }

  Expanded _buildSelectionSheetTitle(
    BuildContext context,
    CategoryLightAdviserViewModel viewModel,
    BottomSheetData selectedBottomSheetData,
    BottomSheetData visibleSheet,
    double maxHeight,
  ) {
    return Expanded(
      child: Opacity(
        opacity: visibleSheet == selectedBottomSheetData ? 1 : 0,
        child: GestureDetector(
          onTap: () => Navigator.pop(context),
          child: Column(
            children: [
              _buildButton(context,
                  showButtonText: false, bottomSheetData: visibleSheet, viewModel: viewModel, maxHeight: maxHeight),
              _buildInfoSheetLabel(
                  context,
                  selectedBottomSheetData == BottomSheetData.brightnessLevels
                      ? _labelCategory.lightAdviser!.categoryBrightnessLabel
                      : _labelCategory.lightAdviser!.categoryColorTemeratureLabel),
              Container(height: 3, width: 55, color: BamColorPalette.bamBlue1),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildInfoSheet(
          {required CategoryLightAdviserViewModel viewModel,
          required BottomSheetData bottomSheetData,
          required BuildContext context,
          required double maxHeight}) =>
      Expanded(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: IconButton(
                onPressed: () => _onTapSelectionButton(viewModel, context, bottomSheetData, maxHeight),
                icon: SvgPicture.asset(
                    AssetPaths.knowHowLightAdviserIconsBasePath + viewModel.sheetIcon(bottomSheetData)),
              ),
            ),
            Text(
              viewModel.topInfo(bottomSheetData),
              style: Theme.of(context).textTheme.subtitle2!.copyWith(color: BamColorPalette.bamBlack80),
            ),
            AnimatedContainer(
                duration: Duration(milliseconds: _animationDuration), height: viewModel.isExpandedLayout ? 8 : 0),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.baseline,
              textBaseline: TextBaseline.alphabetic,
              children: [
                if (bottomSheetData == BottomSheetData.colorTemperature)
                  Flexible(
                    child: Text(
                      _labelCategory.lightAdviser!.approximatelyLabel,
                      style: Theme.of(context).textTheme.subtitle2!.copyWith(color: BamColorPalette.bamBlack80),
                    ),
                  ),
                AnimatedDefaultTextStyle(
                  duration: Duration(milliseconds: _animationDuration),
                  curve: Curves.easeInOut,
                  style: Theme.of(context).textTheme.headline1!.copyWith(
                      fontWeight: FontWeight.bold,
                      color: BamColorPalette.bamBlack80,
                      fontSize: viewModel.isExpandedLayout ? 32 : 28),
                  child: Flexible(
                    child: Text(viewModel.middleInfo(bottomSheetData)),
                  ),
                ),
              ],
            ),
            Text(
              viewModel.bottomInfo(bottomSheetData),
              style: Theme.of(context).textTheme.subtitle2!.copyWith(color: BamColorPalette.bamBlack80),
            ),
            SizedBox(height: 8),
            AnimatedContainer(
              height: viewModel.isExpandedLayout ? 40 : 0,
              curve: Curves.easeInOut,
              duration: Duration(milliseconds: _animationDuration),
              child: AnimatedOpacity(
                duration: Duration(milliseconds: 200),
                curve: Curves.easeInOut,
                opacity: !viewModel.isExpandedLayout ? 0 : 1,
                child: Text(
                  viewModel.additionalInfo(bottomSheetData),
                  style:
                      Theme.of(context).textTheme.subtitle2!.copyWith(color: BamColorPalette.bamBlack80, fontSize: 15),
                  textAlign: TextAlign.center,
                ),
              ),
            ),
          ],
        ),
      );

  Widget _buildBottomLayout(CategoryLightAdviserViewModel viewModel, BuildContext context, double maxHeight) {
    switch (viewModel.bottomLayoutState) {
      case BottomLayoutState.initial:
        return Column(
          children: [
            Row(
              mainAxisSize: MainAxisSize.max,
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Expanded(
                  child: _buildButton(context,
                      showButtonText: false,
                      bottomSheetData: BottomSheetData.brightnessLevels,
                      viewModel: viewModel,
                      maxHeight: maxHeight),
                ),
                Expanded(
                  child: _buildButton(context,
                      showButtonText: false,
                      bottomSheetData: BottomSheetData.colorTemperature,
                      viewModel: viewModel,
                      maxHeight: maxHeight),
                ),
              ],
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 32),
              child: Text(
                _labelCategory.lightAdviser!.selectionHint,
                textAlign: TextAlign.center,
                style: Theme.of(context).textTheme.subtitle2!.copyWith(color: BamColorPalette.bamBlack80),
              ),
            )
          ],
        );
      case BottomLayoutState.left:
        return Row(
          mainAxisSize: MainAxisSize.max,
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            _buildInfoSheet(
              bottomSheetData: BottomSheetData.brightnessLevels,
              viewModel: viewModel,
              context: context,
              maxHeight: maxHeight,
            ),
            Expanded(
              child: _buildButton(context,
                  showButtonText: true,
                  bottomSheetData: BottomSheetData.colorTemperature,
                  viewModel: viewModel,
                  maxHeight: maxHeight),
            ),
          ],
        );
      case BottomLayoutState.right:
        return Row(
          mainAxisSize: MainAxisSize.max,
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Expanded(
              child: _buildButton(context,
                  showButtonText: true,
                  bottomSheetData: BottomSheetData.brightnessLevels,
                  viewModel: viewModel,
                  maxHeight: maxHeight),
            ),
            _buildInfoSheet(
              bottomSheetData: BottomSheetData.colorTemperature,
              viewModel: viewModel,
              context: context,
              maxHeight: maxHeight,
            ),
          ],
        );
      case BottomLayoutState.both:
        return Row(
          mainAxisSize: MainAxisSize.max,
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            _buildInfoSheet(
              bottomSheetData: BottomSheetData.brightnessLevels,
              viewModel: viewModel,
              context: context,
              maxHeight: maxHeight,
            ),
            _buildInfoSheet(
              bottomSheetData: BottomSheetData.colorTemperature,
              viewModel: viewModel,
              context: context,
              maxHeight: maxHeight,
            ),
          ],
        );
    }
  }

  void _onTapSelectionButton(CategoryLightAdviserViewModel viewModel, BuildContext context,
      BottomSheetData bottomSheetData, double maxHeight) async {
    viewModel.isSelectionSheetVisible = true;

    await showModalBottomSheet(
        enableDrag: true,
        isScrollControlled: true,
        barrierColor: Colors.transparent,
        backgroundColor: Colors.transparent,
        builder: (BuildContext context) =>
            _buildSelectionSheet(context, sheetCategory: bottomSheetData, viewModel: viewModel, maxHeight: maxHeight),
        context: context);
    viewModel.isSelectionSheetVisible = false;
  }
}
