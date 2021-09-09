/* * Copyright 2020 Bundesanstalt für Materialforschung und -prüfung (BAM) *
* Licensed under the EUPL, Version 1.2 or – as soon they will be approved by the European Commission - subsequent versions of the EUPL (the "Licence");
* You may not use this work except in compliance with theLicence.
* You may obtain a copy of the Licence at:
* * https://joinup.ec.europa.eu/software/page/eupl *
* Unless required by applicable law or agreed to in writing, software distributed under the Licence is distributed on an "AS IS" basis,
* WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
* See the Licence for the specific language governing permissions and limitations under the Licence.*/

import 'dart:convert';

import 'package:energielabel_app/data/asset_paths.dart';
import 'package:energielabel_app/data/repository_exception.dart';
import 'package:energielabel_app/device_info.dart';
import 'package:energielabel_app/model/know_how/why_is_there/why_is_there.dart';
import 'package:flutter/services.dart';

class WhyIsThereRepository {
  WhyIsThereRepository(AssetBundle assetBundle, DeviceInfo deviceInfo)
      : _assetBundle = assetBundle,
        _deviceInfo = deviceInfo;

  final AssetBundle _assetBundle;
  final DeviceInfo _deviceInfo;

  Future<WhyIsThere> loadWhyIsThere() async {
    return _loadWhyIsThereFromAssets();
  }

  Future<WhyIsThere> _loadWhyIsThereFromAssets() async {
    try {
      final assetJson = await _assetBundle.loadString(AssetPaths.whyIsThereJson(_deviceInfo.bestMatchedLocale));
      return WhyIsThere.fromJson(jsonDecode(assetJson));
    } catch (e) {
      throw RepositoryException('Failed to load WhyIsThere from local assets.', e);
    }
  }
}
