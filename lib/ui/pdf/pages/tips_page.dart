/* * Copyright 2020 Bundesanstalt für Materialforschung und -prüfung (BAM) *
* Licensed under the EUPL, Version 1.2 or – as soon they will be approved by the European Commission - subsequent versions of the EUPL (the "Licence");
* You may not use this work except in compliance with theLicence.
* You may obtain a copy of the Licence at:
* * https://joinup.ec.europa.eu/software/page/eupl *
* Unless required by applicable law or agreed to in writing, software distributed under the Licence is distributed on an "AS IS" basis,
* WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
* See the Licence for the specific language governing permissions and limitations under the Licence.*/

import 'package:energielabel_app/model/know_how/label_guide/label_category_tip_data.dart';
import 'package:energielabel_app/ui/pdf/bam_page.dart';
import 'package:energielabel_app/ui/pdf/components/tip.dart';
import 'package:flutter/foundation.dart';
import 'package:pdf/widgets.dart';

class TipsPage extends StatelessMultiPage {
  TipsPage({@required this.tipsData}) : assert(tipsData != null);

  final LabelCategoryTipData tipsData;

  @override
  List<Widget> build() {
    return [
      _TipsHeader(tipsData.title),
      for (final tip in tipsData.labelTips) Tip(tip),
    ];
  }
}

class _TipsHeader extends StatelessWidget {
  _TipsHeader(this.title);

  final String title;

  @override
  Widget build(Context context) {
    return Padding(
      padding: EdgeInsets.only(top: 20, bottom: 4),
      child: Text(title, style: Theme.of(context).header0),
    );
  }
}
