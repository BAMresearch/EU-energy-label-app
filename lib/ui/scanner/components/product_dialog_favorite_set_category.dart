/* * Copyright 2020 Bundesanstalt für Materialforschung und -prüfung (BAM) *
* Licensed under the EUPL, Version 1.2 or – as soon they will be approved by the European Commission - subsequent versions of the EUPL (the "Licence");
* You may not use this work except in compliance with theLicence.
* You may obtain a copy of the Licence at:
* * https://joinup.ec.europa.eu/software/page/eupl *
* Unless required by applicable law or agreed to in writing, software distributed under the Licence is distributed on an "AS IS" basis,
* WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
* See the Licence for the specific language governing permissions and limitations under the Licence.*/

import 'package:energielabel_app/model/know_how/label_guide/label_category.dart';
import 'package:energielabel_app/ui/misc/components/bam_radio_list_tile.dart';
import 'package:energielabel_app/ui/misc/theme/bam_colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/translations.dart';

class ProductDialogFavoriteSetCategory extends StatefulWidget {
  const ProductDialogFavoriteSetCategory({
    Key? key,
    required this.labelCategories,
    required this.onConfirmCategory,
    required this.onTapCancel,
  }) : super(key: key);

  final List<LabelCategory> labelCategories;
  final Function(LabelCategory? category) onConfirmCategory;
  final VoidCallback onTapCancel;

  @override
  _ProductDialogFavoriteSetCategoryState createState() => _ProductDialogFavoriteSetCategoryState();
}

class _ProductDialogFavoriteSetCategoryState extends State<ProductDialogFavoriteSetCategory> {
  LabelCategory? _selectedCategory;
  bool _valid = true;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(24, 16, 24, 40),
      child: Column(
        mainAxisSize: MainAxisSize.max,
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          ...List.generate(widget.labelCategories.length, (index) {
            final labelCategory = widget.labelCategories[index];
            return Padding(
              padding: const EdgeInsets.symmetric(vertical: 4),
              child: BamRadioListTile(
                title: Text(labelCategory.productType!),
                onChanged: (category) => setState(() => _selectedCategory = labelCategory),
                value: _selectedCategory == labelCategory,
              ),
            );
          }),
          if (!_valid)
            Text(
              Translations.of(context)!.product_favorite_dialog_set_category_error,
              style: Theme.of(context).textTheme.bodyText1!.copyWith(color: Theme.of(context).colorScheme.error),
            ),
          SizedBox(height: 30),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24),
            child: TextButton(
              onPressed: () {
                _valid = _selectedCategory != null;
                setState(() {});
                if (_valid) {
                  return widget.onConfirmCategory(_selectedCategory);
                }
              },
              style: TextButton.styleFrom(
                backgroundColor: Theme.of(context).colorScheme.secondaryVariant,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                padding: const EdgeInsets.only(top: 18, bottom: 14),
              ),
              child: Text(
                Translations.of(context)!.product_favorite_dialog_confirmation_button,
                style: Theme.of(context).textTheme.button!.copyWith(color: BamColorPalette.bamWhite),
              ),
            ),
          ),
          SizedBox(height: 20),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24),
            child: OutlinedButton(
              onPressed: widget.onTapCancel,
              style: OutlinedButton.styleFrom(
                primary: Theme.of(context).colorScheme.surface,
                side: BorderSide(color: BamColorPalette.bamBlue1Optimized),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                padding: const EdgeInsets.only(top: 18, bottom: 14),
              ),
              child: Text(
                Translations.of(context)!.qrcode_product_dialog_cancel,
                style: Theme.of(context).textTheme.button!.copyWith(color: BamColorPalette.bamBlue1Optimized),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
