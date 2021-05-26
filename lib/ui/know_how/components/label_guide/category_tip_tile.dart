/* * Copyright 2020 Bundesanstalt für Materialforschung und -prüfung (BAM) *
* Licensed under the EUPL, Version 1.2 or – as soon they will be approved by the European Commission - subsequent versions of the EUPL (the "Licence");
* You may not use this work except in compliance with theLicence.
* You may obtain a copy of the Licence at:
* * https://joinup.ec.europa.eu/software/page/eupl *
* Unless required by applicable law or agreed to in writing, software distributed under the Licence is distributed on an "AS IS" basis,
* WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
* See the Licence for the specific language governing permissions and limitations under the Licence.*/

import 'package:energielabel_app/model/know_how/label_guide/label_tip.dart';
import 'package:energielabel_app/model/know_how/label_guide/label_tip_view_type.dart';
import 'package:energielabel_app/ui/know_how/components/label_guide/category_tip_image_section.dart';
import 'package:energielabel_app/ui/know_how/components/label_guide/category_tip_image_text_section.dart';
import 'package:energielabel_app/ui/know_how/components/label_guide/category_tip_video_section.dart';
import 'package:energielabel_app/ui/know_how/components/label_guide/general_information_widget.dart';
import 'package:energielabel_app/ui/misc/html_utils.dart';
import 'package:energielabel_app/ui/misc/theme/bam_colors.dart';
import 'package:flutter/material.dart';

class CategoryTipTile extends StatelessWidget {
  CategoryTipTile({
    @required this.tipNumber,
    @required this.labelTip,
    @required this.onLinkTap,
  })  : assert(tipNumber != null),
        assert(labelTip != null),
        assert(onLinkTap != null);

  final int tipNumber;
  final LabelTip labelTip;
  final Future<bool> Function(String url) onLinkTap;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Text(
              '$tipNumber. ${labelTip.title}',
              style: Theme.of(context).textTheme.headline2.copyWith(color: BamColorPalette.bamBlue3),
            ),
          ),

          MergeSemantics(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 10),
                  child: _buildTipContent(),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: HtmlUtils.stringToHtml(
                    context,
                    labelTip.description,
                    onLinkTap: onLinkTap,
                  ),
                ),
              ],
            ),
          ),

          if (labelTip.informationText != null)
            _buildGeneralInformationWidget(context, labelTip.informationTitle, labelTip.informationText)
        ],
      ),
    );
  }

  Widget _buildGeneralInformationWidget(BuildContext context, String title, String informationText) {
    return Padding(
      padding: const EdgeInsets.only(top: 16, left: 16, right: 16),
      child: GeneralInformationWidget(informationTitle: title, informationText: informationText),
    );
  }

  Widget _buildTipContent() {
    switch (labelTip.viewType) {
      case LabelTipViewType.grahpcisText:
        return _buildTipContentImageTexts();
      case LabelTipViewType.graphics:
        return _buildTipContentImage();
      case LabelTipViewType.video:
        return _buildTipContentVideo();
      default:
        return SizedBox.shrink();
    }
  }

  Widget _buildTipContentImageTexts() {
    labelTip.labelTipContentImages
        .sort((contentImage1, contentImage2) => contentImage1.orderIndex.compareTo(contentImage2.orderIndex));
    return Column(
      children: labelTip.labelTipContentImages
          .map((contentImage) => CategoryTipImageTextSection(content: contentImage))
          .toList(),
    );
  }

  Widget _buildTipContentImage() {
    return CategoryTipImageSection(imageData: labelTip.graphicData);
  }

  Widget _buildTipContentVideo() {
    return CategoryTipVideoSection(videoUrl: labelTip.videoPath);
  }
}
