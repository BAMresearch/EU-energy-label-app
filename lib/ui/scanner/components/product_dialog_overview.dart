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
import 'package:flutter_gen/gen_l10n/translations.dart';

class ProductDialogOverview extends StatelessWidget {
  const ProductDialogOverview({
    Key? key,
    required this.message,
    required this.onTapOpenBrowser,
    required this.onTapFavorite,
    required this.onTapCancel,
  }) : super(key: key);

  final String message;
  final VoidCallback onTapOpenBrowser;
  final VoidCallback onTapFavorite;
  final VoidCallback onTapCancel;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(48, 16, 48, 40),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          TextButton(
            onPressed: onTapOpenBrowser,
            style: TextButton.styleFrom(
              backgroundColor: Theme.of(context).colorScheme.secondaryVariant,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
              padding: const EdgeInsets.only(top: 18, bottom: 14),
            ),
            child: Text(
              Translations.of(context)!.qrcode_product_dialog_open,
              style: Theme.of(context).textTheme.button!.copyWith(color: BamColorPalette.bamWhite),
            ),
          ),
          SizedBox(
            height: 20,
          ),
          TextButton(
            onPressed: onTapFavorite,
            style: TextButton.styleFrom(
              backgroundColor: Theme.of(context).colorScheme.secondaryVariant,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
              padding: const EdgeInsets.only(top: 18, bottom: 14),
            ),
            child: Text(
              Translations.of(context)!.qrcode_product_dialog_favorite,
              style: Theme.of(context).textTheme.button!.copyWith(color: BamColorPalette.bamWhite),
            ),
          ),
          SizedBox(
            height: 20,
          ),
          OutlinedButton(
            onPressed: onTapCancel,
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
        ],
      ),
    );
  }
}
