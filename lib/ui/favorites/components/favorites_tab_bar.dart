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

class FavoritesTabBar<T> extends StatelessWidget {
  const FavoritesTabBar({Key? key, this.children, this.groupValue, this.onValueChanged}) : super(key: key);

  final Map<T, String>? children;
  final T? groupValue;
  final Function(T tab)? onValueChanged;

  @override
  Widget build(BuildContext context) {
    return Row(children: [
      for (final entry in children!.entries)
        Expanded(
          child: Material(
            color: groupValue == entry.key ? Theme.of(context).colorScheme.background : BamColorPalette.bamLightGrey,
            child: InkWell(
              onTap: () => onValueChanged!(entry.key),
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical: 16),
                child: Text(
                  entry.value,
                  textAlign: TextAlign.center,
                  style: Theme.of(context).textTheme.subtitle1!.copyWith(
                        color: groupValue == entry.key ? BamColorPalette.bamBlue1Optimized : BamColorPalette.bamBlack30,
                      ),
                ),
              ),
            ),
          ),
        ),
    ]);
  }
}
