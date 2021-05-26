/* * Copyright 2020 Bundesanstalt für Materialforschung und -prüfung (BAM) *
* Licensed under the EUPL, Version 1.2 or – as soon they will be approved by the European Commission - subsequent versions of the EUPL (the "Licence");
* You may not use this work except in compliance with theLicence.
* You may obtain a copy of the Licence at:
* * https://joinup.ec.europa.eu/software/page/eupl *
* Unless required by applicable law or agreed to in writing, software distributed under the Licence is distributed on an "AS IS" basis,
* WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
* See the Licence for the specific language governing permissions and limitations under the Licence.*/

import 'package:shared_preferences/shared_preferences.dart';

class LabelGuideDao {
  LabelGuideDao(SharedPreferences sharedPreferences)
      : assert(sharedPreferences != null),
        _sharedPreferences = sharedPreferences;

  static const String _checklistKeyPrefix = 'checklist';

  final SharedPreferences _sharedPreferences;

  Future<void> saveChecklistEntryState(bool checked, int checklistEntryId, int checklistId) async {
    final String key = _createChecklistEntryKey(checklistId, checklistEntryId);
    await _sharedPreferences.setBool(key, checked);
  }

  bool getChecklistEntryState(int checklistEntryId, int checklistId) {
    final String key = _createChecklistEntryKey(checklistId, checklistEntryId);
    return (_sharedPreferences.getBool(key) ?? false);
  }

  String _createChecklistEntryKey(int checklistId, int checklistEntryId) {
    return '${_checklistKeyPrefix}_${checklistId}_$checklistEntryId';
  }
}
