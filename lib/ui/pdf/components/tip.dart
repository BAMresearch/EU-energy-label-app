/* * Copyright 2020 Bundesanstalt für Materialforschung und -prüfung (BAM) *
* Licensed under the EUPL, Version 1.2 or – as soon they will be approved by the European Commission - subsequent versions of the EUPL (the "Licence");
* You may not use this work except in compliance with theLicence.
* You may obtain a copy of the Licence at:
* * https://joinup.ec.europa.eu/software/page/eupl *
* Unless required by applicable law or agreed to in writing, software distributed under the Licence is distributed on an "AS IS" basis,
* WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
* See the Licence for the specific language governing permissions and limitations under the Licence.*/

import 'dart:convert';
import 'dart:developer';

import 'package:energielabel_app/model/know_how/label_guide/label_tip.dart';
import 'package:energielabel_app/model/know_how/label_guide/label_tip_view_type.dart';
import 'package:energielabel_app/ui/pdf/components/general_info_box.dart';
import 'package:energielabel_app/ui/pdf/utils/pdf_html_utils.dart';
import 'package:pdf/widgets.dart';

class Tip extends StatelessWidget {
  Tip(this.labelTip);

  final LabelTip labelTip;

  @override
  Widget build(Context context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 8),
            child: Text(
              '${labelTip.orderIndex! + 1}. ${labelTip.title}',
              style: Theme.of(context).header2,
            ),
          ),
          SizedBox(height: 8),
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              if (labelTip.viewType == LabelTipViewType.graphics) _buildTipContentImage(),
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.symmetric(vertical: 8),
                  child: PdfHtmlUtils.htmlStringToPdfWidget(context, labelTip.description!),
                ),
              )
            ],
          ),
          SizedBox(height: 8),
          if (labelTip.informationText != null) GeneralInfoBox(content: labelTip.informationText!),
          SizedBox(height: 8),
        ],
      ),
    );
  }

  Widget _buildTipContentImage() {
    final imageData = labelTip.graphicData;

    if (imageData != null && imageData.isNotEmpty) {
      try {
        return Padding(
          padding: const EdgeInsets.only(right: 16),
          child: Image(
            MemoryImage(const Base64Decoder().convert(imageData)),
            width: 200,
          ),
        );
      } catch (error, stacktrace) {
        log('Failed to load image data.', error: error, stackTrace: stacktrace);
        return SizedBox.shrink();
      }
    }
    return SizedBox.shrink();
  }
}
