/* * Copyright 2020 Bundesanstalt für Materialforschung und -prüfung (BAM) *
* Licensed under the EUPL, Version 1.2 or – as soon they will be approved by the European Commission - subsequent versions of the EUPL (the "Licence");
* You may not use this work except in compliance with theLicence.
* You may obtain a copy of the Licence at:
* * https://joinup.ec.europa.eu/software/page/eupl *
* Unless required by applicable law or agreed to in writing, software distributed under the Licence is distributed on an "AS IS" basis,
* WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
* See the Licence for the specific language governing permissions and limitations under the Licence.*/

import 'package:energielabel_app/data/regulation_data_repository.dart';
import 'package:energielabel_app/model/know_how/regulations/regulation.dart';
import 'package:energielabel_app/ui/know_how/know_how_routes.dart';
import 'package:energielabel_app/ui/misc/pages/base_view_model.dart';
import 'package:energielabel_app/ui/misc/pages/view_state.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_fimber/flutter_fimber.dart';

class RegulationsViewModel extends BaseViewModel {
  RegulationsViewModel({
    @required BuildContext context,
    @required RegulationDataRepository regulationDataRepository,
  })  : assert(context != null),
        assert(regulationDataRepository != null),
        _context = context,
        _regulationDataRepository = regulationDataRepository;

  final BuildContext _context;
  final RegulationDataRepository _regulationDataRepository;
  ViewState _viewState = ViewState.uninitialized;
  String _pageTitle;
  String _pageDescription;
  final List<Regulation> _regulations = [];

  ViewState get viewState => _viewState;

  String get pageTitle => _pageTitle;

  String get pageDescription => _pageDescription;

  List<Regulation> get regulations => List.unmodifiable(_regulations);

  @override
  Future<void> onViewStarted() async {
    _viewState = ViewState.initializing;
    notifyListeners();

    try {
      await _loadRegulations();
      _viewState = ViewState.initialized;
    } catch (e) {
      _viewState = ViewState.error;
      Fimber.e('Failed to initialize regulations page contents.', ex: e);
    } finally {
      notifyListeners();
    }
  }

  void onRegulationSelected(Regulation regulation) {
    Navigator.of(_context).pushNamed(KnowHowRoutes.regulationDetails, arguments: regulation);
  }

  Future<void> _loadRegulations() async {
    final regulationsData = await _regulationDataRepository.loadRegulationData();
    _pageTitle = regulationsData.title;
    _pageDescription = regulationsData.description;
    _regulations.addAll(regulationsData.regulations);
  }
}
