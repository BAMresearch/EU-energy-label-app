/* * Copyright 2020 Bundesanstalt für Materialforschung und -prüfung (BAM) *
* Licensed under the EUPL, Version 1.2 or – as soon they will be approved by the European Commission - subsequent versions of the EUPL (the "Licence");
* You may not use this work except in compliance with theLicence.
* You may obtain a copy of the Licence at:
* * https://joinup.ec.europa.eu/software/page/eupl *
* Unless required by applicable law or agreed to in writing, software distributed under the Licence is distributed on an "AS IS" basis,
* WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
* See the Licence for the specific language governing permissions and limitations under the Licence.*/

import 'dart:convert';

import 'package:collection/collection.dart' show IterableExtension;
import 'package:energielabel_app/data/asset_paths.dart';
import 'package:energielabel_app/data/persistence/label_guide_dao.dart';
import 'package:energielabel_app/data/repository_exception.dart';
import 'package:energielabel_app/device_info.dart';
import 'package:energielabel_app/model/know_how/label_guide/label_category.dart';
import 'package:energielabel_app/model/know_how/label_guide/label_category_checklist_data.dart';
import 'package:energielabel_app/model/know_how/label_guide/label_category_tip_data.dart';
import 'package:energielabel_app/model/know_how/label_guide/label_guide.dart';
import 'package:flutter/services.dart';

class LabelGuideRepository {
  LabelGuideRepository(AssetBundle assetBundle, DeviceInfo deviceInfo, LabelGuideDao? labelGuideDao)
      : _assetBundle = assetBundle,
        _deviceInfo = deviceInfo,
        _labelGuideDao = labelGuideDao;

  final AssetBundle _assetBundle;
  final DeviceInfo _deviceInfo;
  final LabelGuideDao? _labelGuideDao;

  Future<List<LabelCategory>> getCategories() async {
    final labelGuide = await loadLabelGuide();
    return List.unmodifiable(labelGuide.labelCategories!);
  }

  Future<LabelCategory?> getCategory(int? categoryId) async {
    final labelGuide = await loadLabelGuide();
    return labelGuide.labelCategories!.singleWhereOrNull((category) => category.id == categoryId);
  }

  Future<LabelCategory?> getCategoryForId(int? categoryId) async {
    final labelGuide = await loadLabelGuide();
    for (final category in labelGuide.labelCategories!) {
      if (categoryId == category.id) {
        return category;
      }
    }
    return null;
  }

  Future<LabelCategory?> getCategoryForChecklistData(LabelCategoryChecklistData labelCategoryChecklistData) async {
    final labelGuide = await loadLabelGuide();
    for (final category in labelGuide.labelCategories!) {
      if (category.checklistData == labelCategoryChecklistData) {
        return category;
      }
    }
    return null;
  }

  Future<LabelCategory?> getCategoryForTips(LabelCategoryTipData tipData) async {
    final labelGuide = await loadLabelGuide();
    for (final category in labelGuide.labelCategories!) {
      if (category.tipData == tipData) {
        return category;
      }
    }
    return null;
  }

  Future<LabelGuide> loadLabelGuide() async {
    return _loadLabelGuideFromAssets();
  }

  Future<LabelGuide> _loadLabelGuideFromAssets() async {
    try {
      final assetJson = await _assetBundle.loadString(AssetPaths.labelGuideJson(_deviceInfo.bestMatchedLocale));
      return LabelGuide.fromJson(jsonDecode(assetJson));
    } catch (e) {
      throw RepositoryException('Failed to load label guide from local assets.', e);
    }
  }

  Future<void> saveCheckboxEntryState(bool checked, int? checklistEntryId, int? checklistId) async {
    await _labelGuideDao!.saveChecklistEntryState(checked, checklistEntryId, checklistId);
  }

  bool getCheckboxEntryState(int? checklistEntryId, int? checklistId) {
    return _labelGuideDao!.getChecklistEntryState(checklistEntryId, checklistId);
  }
}
