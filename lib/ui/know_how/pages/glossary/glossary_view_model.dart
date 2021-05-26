/* * Copyright 2020 Bundesanstalt für Materialforschung und -prüfung (BAM) *
* Licensed under the EUPL, Version 1.2 or – as soon they will be approved by the European Commission - subsequent versions of the EUPL (the "Licence");
* You may not use this work except in compliance with theLicence.
* You may obtain a copy of the Licence at:
* * https://joinup.ec.europa.eu/software/page/eupl *
* Unless required by applicable law or agreed to in writing, software distributed under the Licence is distributed on an "AS IS" basis,
* WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
* See the Licence for the specific language governing permissions and limitations under the Licence.*/

import 'package:energielabel_app/data/glossary_repository.dart';
import 'package:energielabel_app/model/know_how/glossary/glossary_entry.dart';
import 'package:energielabel_app/ui/misc/pages/base_view_model.dart';
import 'package:energielabel_app/ui/misc/pages/view_state.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_fimber/flutter_fimber.dart';
import 'package:pedantic/pedantic.dart';

class GlossaryViewModel extends BaseViewModel {
  GlossaryViewModel(
      {@required GlossaryRepository glossaryRepository,
      GlossaryEntry initialSelectedGlossaryEntry,
      String initialFilterInput})
      : assert(glossaryRepository != null),
        _initialSelectedGlossaryEntry = initialSelectedGlossaryEntry,
        _glossaryRepository = glossaryRepository,
        _filterInput = initialFilterInput ?? '';

  final GlossaryEntry _initialSelectedGlossaryEntry;
  final GlossaryRepository _glossaryRepository;
  ViewState _viewState = ViewState.uninitialized;
  final List<GlossaryEntry> _allGlossaryEntries = [];
  String get filterInput => _filterInput;
  String _filterInput;

  ViewState get viewState => _viewState;

  List<GlossaryEntry> get glossaryEntries {
    if (_filterInput.isNotEmpty) {
      return _allGlossaryEntries.where((glossaryEntry) {
        final titleMatches = glossaryEntry.title.toLowerCase().contains(_filterInput.toLowerCase());
        final descriptionMatches = glossaryEntry.description.toLowerCase().contains(_filterInput.toLowerCase());
        return titleMatches || descriptionMatches;
      }).toList();
    }
    return List.unmodifiable(_allGlossaryEntries);
  }

  int get initialSelectedGlossaryEntry {
    final int index = glossaryEntries.indexOf(_initialSelectedGlossaryEntry);
    if (index == -1) {
      return 0;
    }
    return index;
  }

  @override
  void onViewStarted() {
    unawaited(_loadGlossaryEntries());
  }

  void onFilterInputChanged(String filterInput) {
    _filterInput = filterInput;
    notifyListeners();
  }

  Future<void> _loadGlossaryEntries() async {
    try {
      _viewState = ViewState.initializing;
      notifyListeners();

      final glossary = await _glossaryRepository.loadGlossary();
      _allGlossaryEntries.addAll(glossary.glossaryEntries);
      _viewState = ViewState.initialized;
    } catch (e) {
      Fimber.e('Failed to load the glossary entries', ex: e);
      _viewState = ViewState.error;
    } finally {
      notifyListeners();
    }
  }

  String highlightString(String text) {
    if (filterInput == null || filterInput.isEmpty) {
      return text;
    }

    final String lowerCaseText = text.toLowerCase();

    final List<String> textComponents = [];
    final List<Match> matches = [];

    lowerCaseText.replaceAllMapped(filterInput.toLowerCase(), (match) {
      matches.add(match);

      return filterInput;
    });

    if (matches.isNotEmpty) {
      if (matches.first.start != 0) {
        final String component = text.substring(0, matches.first.start);
        textComponents.add(component);
      }
    } else {
      return text;
    }

    for (int i = 0; i < matches.length; i++) {
      String hit = text.substring(matches[i].start, matches[i].end);
      hit = '<span>$hit</span>';
      textComponents.add(hit);

      final int start = matches[i].end;
      final int end = i + 1 < matches.length ? matches[i + 1].start : text.length;

      final String component = text.substring(start, end);
      textComponents.add(component);
    }

    return textComponents.join();
  }
}
