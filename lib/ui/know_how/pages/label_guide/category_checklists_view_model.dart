/* * Copyright 2020 Bundesanstalt für Materialforschung und -prüfung (BAM) *
* Licensed under the EUPL, Version 1.2 or – as soon they will be approved by the European Commission - subsequent versions of the EUPL (the "Licence");
* You may not use this work except in compliance with theLicence.
* You may obtain a copy of the Licence at:
* * https://joinup.ec.europa.eu/software/page/eupl *
* Unless required by applicable law or agreed to in writing, software distributed under the Licence is distributed on an "AS IS" basis,
* WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
* See the Licence for the specific language governing permissions and limitations under the Licence.*/

import 'dart:async';

import 'package:energielabel_app/data/favorite_repository.dart';
import 'package:energielabel_app/data/label_guide_repository.dart';
import 'package:energielabel_app/model/favorite.dart';
import 'package:energielabel_app/model/know_how/label_guide/checklist_entry.dart';
import 'package:energielabel_app/model/know_how/label_guide/label_category.dart';
import 'package:energielabel_app/model/know_how/label_guide/label_category_checklist.dart';
import 'package:energielabel_app/model/know_how/label_guide/label_category_checklist_data.dart';
import 'package:energielabel_app/ui/know_how/favorite_action_listener.dart';
import 'package:energielabel_app/ui/misc/pages/base_view_model.dart';
import 'package:flutter_fimber/flutter_fimber.dart';
import 'package:rxdart/rxdart.dart';

class CategoryChecklistsViewModel extends BaseViewModel {
  CategoryChecklistsViewModel({
    required LabelCategoryChecklistData labelCategoryChecklistData,
    required LabelCategory labelCategory,
    required LabelGuideRepository labelGuideRepository,
    required FavoriteRepository favoriteRepository,
    required FavoriteActionListener favoriteActionListener,
  })   : _labelCategoryChecklistData = labelCategoryChecklistData,
        _labelCategory = labelCategory,
        _checklistFavorite = ChecklistFavorite(categoryId: labelCategory.id),
        _favoriteRepository = favoriteRepository,
        _labelGuideRepository = labelGuideRepository,
        _favoriteActionListener = favoriteActionListener;

  final LabelGuideRepository _labelGuideRepository;

  final ChecklistFavorite _checklistFavorite;
  final LabelCategoryChecklistData _labelCategoryChecklistData;
  final LabelCategory _labelCategory;
  final FavoriteRepository _favoriteRepository;
  final FavoriteActionListener _favoriteActionListener;
  final CompositeSubscription _subscriptions = CompositeSubscription();
  String? _headerBackgroundColorHex = '00FFFFFF';
  String? _headerTextColorHex = '00FFFFFF';

  bool _isFavorite = false;

  String? get description => _labelCategoryChecklistData.introText;

  String? get title => _labelCategoryChecklistData.title;
  String? get graphicPath => _labelCategory.graphicPath;

  String? get headerBackgroundColorHex => _headerBackgroundColorHex;
  String? get headerTextColorHex => _headerTextColorHex;

  String? get informationTitle => _labelCategoryChecklistData.informationTitle;

  String? get informationText => _labelCategoryChecklistData.informationText;

  List<LabelCategoryChecklist>? get checklists => _labelCategoryChecklistData.checklists;

  bool get isFavorite => _isFavorite;

  @override
  Future<void> onViewStarted() async {
    _headerBackgroundColorHex =
        (await _labelGuideRepository.getCategoryForChecklistData(_labelCategoryChecklistData))!.backgroundColorHex;
    _headerTextColorHex =
        (await _labelGuideRepository.getCategoryForChecklistData(_labelCategoryChecklistData))!.textColorHex;
    await _loadChecklistEntryStates();
    _observeFavoriteUpdates();
    notifyListeners();
  }

  @override
  void dispose() {
    _subscriptions.clear();
    super.dispose();
  }

  Future<void> onChecklistEntryTapped(
      bool checked, ChecklistEntry checklistEntry, LabelCategoryChecklist checklist) async {
    checklistEntry.checked = checked;

    await _labelGuideRepository.saveCheckboxEntryState(checked, checklistEntry.id, checklist.id);
    notifyListeners();
  }

  void onFavoriteButtonTapped() {
    _isFavorite ? _removeFavorite() : _addFavorite();
    notifyListeners();
  }

  Future<void> _removeFavorite() async {
    try {
      await _favoriteRepository.removeChecklistFavorite(_checklistFavorite);
      _favoriteActionListener.onRemoveFavoriteSuccess();
    } catch (e) {
      Fimber.e('Failed to remove favorite.', ex: e);
      _favoriteActionListener.onRemoveFavoriteFailure();
    }
  }

  Future<void> _addFavorite() async {
    try {
      await _favoriteRepository.addChecklistFavorite(_checklistFavorite);
      _favoriteActionListener.onAddFavoriteSuccess();
    } catch (e) {
      Fimber.e('Failed to add favorite.', ex: e);
      _favoriteActionListener.onAddFavoriteFailure();
    }
  }

  void _observeFavoriteUpdates() {
    _subscriptions.add(
      _favoriteRepository.favoriteChecklistsUpdates.listen((favoriteChecklists) {
        _isFavorite = favoriteChecklists.contains(_checklistFavorite);
        notifyListeners();
      }),
    );
  }

  Future<void> _loadChecklistEntryStates() async {
    for (final checklist in checklists!) {
      for (final checklistEntry in checklist.checklistEntries!) {
        checklistEntry.checked = _labelGuideRepository.getCheckboxEntryState(checklistEntry.id, checklist.id);
      }
    }
  }
}
