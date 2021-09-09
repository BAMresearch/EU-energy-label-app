/* * Copyright 2020 Bundesanstalt für Materialforschung und -prüfung (BAM) *
* Licensed under the EUPL, Version 1.2 or – as soon they will be approved by the European Commission - subsequent versions of the EUPL (the "Licence");
* You may not use this work except in compliance with theLicence.
* You may obtain a copy of the Licence at:
* * https://joinup.ec.europa.eu/software/page/eupl *
* Unless required by applicable law or agreed to in writing, software distributed under the Licence is distributed on an "AS IS" basis,
* WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
* See the Licence for the specific language governing permissions and limitations under the Licence.*/

import 'package:energielabel_app/data/asset_paths.dart';
import 'package:energielabel_app/ui/favorites/favorite_list_item.dart';
import 'package:energielabel_app/ui/favorites/pages/favorite_type.dart';
import 'package:energielabel_app/ui/misc/components/circular_flat_button.dart';
import 'package:energielabel_app/ui/misc/theme/bam_colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/translations.dart';
import 'package:flutter_svg/flutter_svg.dart';

class FavoriteSectionItem extends StatelessWidget {
  const FavoriteSectionItem({
    Key? key,
    required this.favoriteListSection,
    this.onEntryPressed,
    this.onEditPressed,
  }) : super(key: key);

  final FavoriteListSection favoriteListSection;
  final Function(FavoriteListSectionEntry sectionEntry)? onEntryPressed;
  final Function(FavoriteType favoriteTyp, int? categoryId)? onEditPressed;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 12),
      child: DecoratedBox(
        decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.surface,
          border: Border.all(color: Theme.of(context).colorScheme.surface),
          borderRadius: BorderRadius.all(Radius.circular(8)),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Expanded(
                  child: Semantics(
                    label: favoriteListSection.title,
                    excludeSemantics: true,
                    inMutuallyExclusiveGroup: true,
                    child: Padding(
                      padding: const EdgeInsets.only(top: 16, bottom: 8, left: 16, right: 16),
                      child: Text(
                        favoriteListSection.title,
                        style: Theme.of(context).textTheme.bodyText2!.copyWith(color: BamColorPalette.bamBlue3),
                      ),
                    ),
                  ),
                ),
                Semantics(
                  label: Translations.of(context)!.favorites_edit_list_button_semantics(favoriteListSection.title),
                  excludeSemantics: true,
                  inMutuallyExclusiveGroup: true,
                  button: true,
                  onTap: () => onEditPressed?.call(
                    favoriteListSection.favoriteType,
                    favoriteListSection.productCategory,
                  ),
                  child: Padding(
                    padding: const EdgeInsets.only(top: 8, left: 4, right: 4),
                    child: CircularFlatButton(
                      padding: const EdgeInsets.all(8),
                      onPressed: () => onEditPressed?.call(
                        favoriteListSection.favoriteType,
                        favoriteListSection.productCategory,
                      ),
                      child: SvgPicture.asset(AssetPaths.favoriteEditIcon),
                    ),
                  ),
                )
              ],
            ),
            Divider(),
            ListView.builder(
              shrinkWrap: true,
              padding: const EdgeInsets.only(bottom: 12),
              physics: NeverScrollableScrollPhysics(),
              itemCount: favoriteListSection.sectionEntries.length,
              itemBuilder: (context, index) {
                final sectionEntry = favoriteListSection.sectionEntries[index];
                return Material(
                  color: Colors.transparent,
                  child: InkWell(
                    onTap: () => onEntryPressed?.call(sectionEntry),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
                      child: Text(
                        sectionEntry.title,
                        style:
                            Theme.of(context).textTheme.bodyText2!.copyWith(color: BamColorPalette.bamBlue1Optimized),
                      ),
                    ),
                  ),
                );
              },
            )
          ],
        ),
      ),
    );
  }
}
