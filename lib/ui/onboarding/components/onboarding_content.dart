/* * Copyright 2020 Bundesanstalt für Materialforschung und -prüfung (BAM) *
* Licensed under the EUPL, Version 1.2 or – as soon they will be approved by the European Commission - subsequent versions of the EUPL (the "Licence");
* You may not use this work except in compliance with theLicence.
* You may obtain a copy of the Licence at:
* * https://joinup.ec.europa.eu/software/page/eupl *
* Unless required by applicable law or agreed to in writing, software distributed under the Licence is distributed on an "AS IS" basis,
* WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
* See the Licence for the specific language governing permissions and limitations under the Licence.*/

import 'package:energielabel_app/ui/misc/theme/bam_colors.dart';
import 'package:flutter/material.dart';

class OnboardingItem {
  OnboardingItem(this.title, this.semanticTitle, this.description, this.imageAsset);

  final String title;
  final String? semanticTitle;
  final String description;
  final String? imageAsset;
}

class OnboardingContent extends StatelessWidget {
  const OnboardingContent(this.item);

  final OnboardingItem item;

  static double imageHeight(BuildContext context) => MediaQuery.of(context).size.height * 0.5;

  @override
  Widget build(BuildContext context) {
    final double width = MediaQuery.of(context).size.width > 500 ? 500 : double.infinity;
    final double foregroundImageHeight = imageHeight(context);
    final ScrollController scrollController = ScrollController();

    return Padding(
      padding: EdgeInsets.only(top: foregroundImageHeight),
      child: Scrollbar(
        controller: scrollController,
        isAlwaysShown: true,
        child: SingleChildScrollView(
          controller: scrollController,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                SizedBox(
                  width: width,
                  child: Text(
                    item.title,
                    style: Theme.of(context).textTheme.headline1!.copyWith(color: BamColorPalette.bamBlue3),
                    textAlign: TextAlign.center,
                    semanticsLabel: item.semanticTitle,
                  ),
                ),
                SizedBox(height: 24),
                SizedBox(
                  width: width,
                  child: Text(
                    item.description,
                    textAlign: TextAlign.center,
                    style: Theme.of(context).textTheme.bodyText2!.copyWith(color: BamColorPalette.bamBlack80),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
