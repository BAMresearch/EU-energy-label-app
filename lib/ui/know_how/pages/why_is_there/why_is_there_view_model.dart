/* * Copyright 2020 Bundesanstalt für Materialforschung und -prüfung (BAM) *
* Licensed under the EUPL, Version 1.2 or – as soon they will be approved by the European Commission - subsequent versions of the EUPL (the "Licence");
* You may not use this work except in compliance with theLicence.
* You may obtain a copy of the Licence at:
* * https://joinup.ec.europa.eu/software/page/eupl *
* Unless required by applicable law or agreed to in writing, software distributed under the Licence is distributed on an "AS IS" basis,
* WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
* See the Licence for the specific language governing permissions and limitations under the Licence.*/

import 'dart:async';

import 'package:energielabel_app/data/why_is_there_repository.dart';
import 'package:energielabel_app/model/know_how/why_is_there/why_is_there.dart';
import 'package:energielabel_app/model/know_how/why_is_there/why_is_there_entry.dart';
import 'package:energielabel_app/ui/misc/pages/base_view_model.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_fimber/flutter_fimber.dart';

class WhyIsThereViewModel extends BaseViewModel {
  WhyIsThereViewModel({@required WhyIsThereRepository whyIsThereRepository, @required int initialIndex})
      : assert(WhyIsThereRepository != null),
        _whyIsThereRepository = whyIsThereRepository,
        _currentPageIndex = initialIndex;

  final WhyIsThereRepository _whyIsThereRepository;
  final List<WhyIsThereEntry> _whyIsThereEntries = [];

  WhyIsThere _whyIsThere;

  int _currentPageIndex;

  int get pageCount => _whyIsThereEntries.length;
  int get currentPageIndex => _currentPageIndex;

  @override
  Future<void> onViewStarted() async {
    await _loadEntries();
  }

  Future<void> _loadEntries() async {
    try {
      _whyIsThere = await _whyIsThereRepository.loadWhyIsThere();
      _whyIsThereEntries.addAll(_whyIsThere.entries);
      _whyIsThereEntries.sort(
        (whyIsThereEntryA, whyIsThereEntryB) => whyIsThereEntryA.orderIndex.compareTo(whyIsThereEntryB.orderIndex),
      );
    } catch (e) {
      Fimber.e('Failed to load the why is there entries', ex: e);
      throw Error();
    } finally {
      notifyListeners();
    }
  }

  WhyIsThereEntry entry(int index) => _whyIsThereEntries[index];

  void onPageChangeAction(int index) {
    _currentPageIndex = index;
    notifyListeners();
  }
}
