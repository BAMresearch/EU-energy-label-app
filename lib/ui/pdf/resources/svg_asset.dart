/* * Copyright 2020 Bundesanstalt für Materialforschung und -prüfung (BAM) *
* Licensed under the EUPL, Version 1.2 or – as soon they will be approved by the European Commission - subsequent versions of the EUPL (the "Licence");
* You may not use this work except in compliance with theLicence.
* You may obtain a copy of the Licence at:
* * https://joinup.ec.europa.eu/software/page/eupl *
* Unless required by applicable law or agreed to in writing, software distributed under the Licence is distributed on an "AS IS" basis,
* WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
* See the Licence for the specific language governing permissions and limitations under the Licence.*/

import 'package:flutter/foundation.dart';
import 'package:pdf/widgets.dart';

class SvgAsset extends StatelessWidget {
  SvgAsset({
    @required this.data,
    @required this.child,
  })  : assert(data != null),
        assert(child != null);

  final SvgAssetData data;

  final Widget child;

  static SvgAssetData of(Context context) {
    return context.dependsOn<SvgAssetData>();
  }

  static String getSvgString(Context context, String asset) {
    final SvgAssetData data = context.dependsOn<SvgAssetData>();
    return data.getSvgAsset(asset);
  }

  @override
  Widget build(Context context) {
    return InheritedWidget(
      inherited: data,
      build: (Context context) => child,
    );
  }
}

class SvgAssetData extends Inherited {
  SvgAssetData(this.data);

  final Map<String, String> data;

  String getSvgAsset(String asset) {
    return data[asset];
  }
}
