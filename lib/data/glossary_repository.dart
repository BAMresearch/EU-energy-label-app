/* * Copyright 2020 Bundesanstalt für Materialforschung und -prüfung (BAM) *
* Licensed under the EUPL, Version 1.2 or – as soon they will be approved by the European Commission - subsequent versions of the EUPL (the "Licence");
* You may not use this work except in compliance with theLicence.
* You may obtain a copy of the Licence at:
* * https://joinup.ec.europa.eu/software/page/eupl *
* Unless required by applicable law or agreed to in writing, software distributed under the Licence is distributed on an "AS IS" basis,
* WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
* See the Licence for the specific language governing permissions and limitations under the Licence.*/

import 'dart:convert';

import 'package:diacritic/diacritic.dart';
import 'package:energielabel_app/data/asset_paths.dart';
import 'package:energielabel_app/data/repository_exception.dart';
import 'package:energielabel_app/device_info.dart';
import 'package:energielabel_app/model/know_how/glossary/glossary.dart';
import 'package:flutter/services.dart';

class GlossaryRepository {
  GlossaryRepository(AssetBundle assetBundle, DeviceInfo deviceInfo)
      : assert(assetBundle != null),
        assert(deviceInfo != null),
        _assetBundle = assetBundle,
        _deviceInfo = deviceInfo;

  final AssetBundle _assetBundle;
  final DeviceInfo _deviceInfo;

  Future<Glossary> loadGlossary() async {
    return _loadGlossaryFromAssets();
  }

  Future<Glossary> _loadGlossaryFromAssets() async {
    try {
      final assetJson = await _assetBundle.loadString(AssetPaths.glossaryJson(_deviceInfo.bestMatchedLocale));
      final glossary = Glossary.fromJson(jsonDecode(assetJson));
      glossary.glossaryEntries.sort((glossaryEntry1, glossaryEntry2) =>
          removeDiacritics(glossaryEntry1.title).compareTo(removeDiacritics(glossaryEntry2.title)));
      return glossary;
    } catch (e) {
      throw RepositoryException('Failed to load glossary from local assets.', e);
    }
  }
}
