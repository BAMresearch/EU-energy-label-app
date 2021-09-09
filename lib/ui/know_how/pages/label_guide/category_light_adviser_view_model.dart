/* * Copyright 2020 Bundesanstalt für Materialforschung und -prüfung (BAM) *
* Licensed under the EUPL, Version 1.2 or – as soon they will be approved by the European Commission - subsequent versions of the EUPL (the "Licence");
* You may not use this work except in compliance with theLicence.
* You may obtain a copy of the Licence at:
* * https://joinup.ec.europa.eu/software/page/eupl *
* Unless required by applicable law or agreed to in writing, software distributed under the Licence is distributed on an "AS IS" basis,
* WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
* See the Licence for the specific language governing permissions and limitations under the Licence.*/

import 'dart:async';

import 'package:energielabel_app/data/asset_paths.dart';
import 'package:energielabel_app/model/know_how/label_guide/label_category_light_adviser.dart';
import 'package:energielabel_app/ui/know_how/know_how_routes.dart';
import 'package:energielabel_app/ui/misc/pages/base_view_model.dart';
import 'package:energielabel_app/ui/misc/theme/bam_colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

import 'category_light_adviser_info_page.dart';

enum BottomLayoutState { initial, left, right, both }
enum BottomSheetData { brightnessLevels, colorTemperature }

class CategoryLightAdviserViewModel extends BaseViewModel {
  CategoryLightAdviserViewModel(BuildContext context, LabelCategoryLightAdviser lightAdviser)
      : _context = context,
        _lightAdviser = lightAdviser;

  final LabelCategoryLightAdviser _lightAdviser;
  final BuildContext _context;

  SvgPicture get toggleIcon => _isExpandedLayout
      ? SvgPicture.asset(
          AssetPaths.knowHowLightAdviserArrowDownIcon,
          color: BamColorPalette.bamBlack80,
        )
      : SvgPicture.asset(
          AssetPaths.knowHowLightAdviserArrowUpIcon,
          color: BamColorPalette.bamBlack80,
        );

  bool get isExpandedLayout => _isExpandedLayout;
  bool get isSelectionSheetVisible => _isSelectionSheetVisible;
  bool get shouldShowExpansionToggleButton => bottomLayoutState != BottomLayoutState.initial;

  BottomLayoutState get bottomLayoutState {
    if (_selectedBrightnessLevel != null && _selectedRoom != null) {
      return BottomLayoutState.both;
    } else if (_selectedBrightnessLevel == null && _selectedRoom == null) {
      return BottomLayoutState.initial;
    } else if (_selectedBrightnessLevel != null && _selectedRoom == null) {
      return BottomLayoutState.left;
    } else {
      return BottomLayoutState.right;
    }
  }

  String bulbImageFileName() {
    String bulbImageFileName = 'BAM_Energielabel-Glühbirne_aus.png';

    if (_selectedRoom == null && _selectedBrightnessLevel == null) {
      return bulbImageFileName;
    }

    final RoomType room = _selectedRoom ?? RoomType.mirror;
    final BrightnessType brightnessType = _selectedBrightnessLevel ?? BrightnessType.lowLight;

    _lightAdviser.bulbImages.forEach((bulbImage) {
      bulbImage.brightnessRoom.forEach((brightnessRoom) {
        if (brightnessRoom.brightness == brightnessType && brightnessRoom.room == room) {
          bulbImageFileName = bulbImage.image;
        }
      });
    });

    return bulbImageFileName;
  }

  bool _isExpandedLayout = false;
  bool _isSelectionSheetVisible = false;

  BrightnessType? _selectedBrightnessLevel;
  RoomType? _selectedRoom;
  BoxConstraints? bodyConstraints;

  set isSelectionSheetVisible(bool isSelectionSheetVisible) {
    _isSelectionSheetVisible = isSelectionSheetVisible;
    notifyListeners();
  }

  BrightnessType? get selectedBrightnessLevel => _selectedBrightnessLevel;

  set selectedBrightnessLevel(BrightnessType? selectedBrightnessLevel) {
    _selectedBrightnessLevel = selectedBrightnessLevel;
    notifyListeners();
  }

  RoomType? get selectedRoom => _selectedRoom;

  set selectedRoom(RoomType? selectedRoom) {
    _selectedRoom = selectedRoom;
    notifyListeners();
  }

  @override
  FutureOr<void> onViewStarted() {}

  void onExpansionToggleTap() {
    _isExpandedLayout = !_isExpandedLayout;
    notifyListeners();
  }

  void onInfoButtonTapped(CategoryLightAdviserInfoPageArguments arguments) =>
      Navigator.of(_context).pushNamed(KnowHowRoutes.labelGuideCategoryLightInfo, arguments: arguments);

  String topInfo(BottomSheetData bottomSheetData) => (bottomSheetData == BottomSheetData.brightnessLevels)
      ? _lightAdviser.brightnessInfoSheetTopLabel.toUpperCase()
      : _lightAdviser.rooms[_selectedRoom]!.label.toUpperCase();

  String middleInfo(BottomSheetData bottomSheetData) => (bottomSheetData == BottomSheetData.brightnessLevels)
      ? _lightAdviser.brightnessLevels[_selectedBrightnessLevel]!.brightness
      : _lightAdviser.rooms[_selectedRoom]!.temperature;

  String bottomInfo(BottomSheetData bottomSheetData) => (bottomSheetData == BottomSheetData.brightnessLevels)
      ? _lightAdviser.brightnessUnit.toUpperCase()
      : _lightAdviser.colorTemperatureUnit.toUpperCase();

  String additionalInfo(BottomSheetData bottomSheetData) => (bottomSheetData == BottomSheetData.brightnessLevels)
      ? _lightAdviser.brightnessLevels[_selectedBrightnessLevel]!.power
      : _lightAdviser.rooms[_selectedRoom]!.description;

  String sheetIcon(BottomSheetData bottomSheetData) => (bottomSheetData == BottomSheetData.brightnessLevels)
      ? _lightAdviser.brightnessLevels[_selectedBrightnessLevel]!.iconFileName
      : _lightAdviser.rooms[_selectedRoom]!.iconFileName;
}
