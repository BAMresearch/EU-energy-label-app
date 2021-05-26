/* * Copyright 2020 Bundesanstalt für Materialforschung und -prüfung (BAM) *
* Licensed under the EUPL, Version 1.2 or – as soon they will be approved by the European Commission - subsequent versions of the EUPL (the "Licence");
* You may not use this work except in compliance with theLicence.
* You may obtain a copy of the Licence at:
* * https://joinup.ec.europa.eu/software/page/eupl *
* Unless required by applicable law or agreed to in writing, software distributed under the Licence is distributed on an "AS IS" basis,
* WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
* See the Licence for the specific language governing permissions and limitations under the Licence.*/

import 'package:energielabel_app/data/label_guide_repository.dart';
import 'package:energielabel_app/model/know_how/label_guide/label_category.dart';
import 'package:energielabel_app/model/know_how/label_guide/label_guide.dart';
import 'package:energielabel_app/ui/know_how/know_how_routes.dart';
import 'package:energielabel_app/ui/misc/pages/base_view_model.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_fimber/flutter_fimber.dart';

class CategoriesOverviewViewModel extends BaseViewModel {
  CategoriesOverviewViewModel({
    @required LabelGuideRepository labelGuideRepository,
    @required BuildContext context,
  })  : assert(labelGuideRepository != null),
        assert(context != null),
        _labelGuideRepository = labelGuideRepository,
        _context = context;

  final LabelGuideRepository _labelGuideRepository;

  final List<LabelCategory> _labelCategories = [];

  final BuildContext _context;

  LabelGuide _labelGuide;

  List<LabelCategory> get labelCategories => List.unmodifiable(_labelCategories);

  String get title => _labelGuide?.title ?? '';

  @override
  Future<void> onViewStarted() async {
    await _loadLabelCategories();
    notifyListeners();
  }

  Future<void> _loadLabelCategories() async {
    try {
      _labelGuide = await _labelGuideRepository.loadLabelGuide();
      _labelCategories.addAll(_labelGuide.labelCategories
          .where((labelCategory) => labelCategory.visible == true && labelCategory.favoriteOnly == false));
      _labelCategories.sort(
        (labelCategoryA, labelCategoryB) => labelCategoryA.orderIndex.compareTo(labelCategoryB.orderIndex),
      );
    } catch (e) {
      Fimber.e('Failed to load the label categories', ex: e);
      throw Error();
    }
  }

  void onCategoryTapped(LabelCategory category) {
    Navigator.of(_context).pushNamed(KnowHowRoutes.labelGuideCategoryOverview, arguments: category);
  }
}
