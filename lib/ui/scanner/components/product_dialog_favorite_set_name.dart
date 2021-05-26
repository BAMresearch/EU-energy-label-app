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

class ProductDialogFavoriteSetName extends StatefulWidget {
  const ProductDialogFavoriteSetName({
    Key key,
    @required this.onConfirmName,
    @required this.onTapCancel,
  })  : assert(onConfirmName != null),
        assert(onTapCancel != null),
        super(key: key);

  final Function(String name) onConfirmName;
  final VoidCallback onTapCancel;

  @override
  _ProductDialogFavoriteSetNameState createState() => _ProductDialogFavoriteSetNameState();
}

class _ProductDialogFavoriteSetNameState extends State<ProductDialogFavoriteSetName> {
  String _title = '';
  bool _valid = true;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(48, 16, 48, 40),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          TextField(
            autofocus: false,
            onChanged: (input) => setState(() => _title = input),
            decoration: InputDecoration(
              hintText: Translations.of(context).product_favorite_dialog_set_title_hint,
              enabledBorder: OutlineInputBorder(),
              focusedBorder: OutlineInputBorder(
                borderSide: BorderSide(color: Theme.of(context).colorScheme.secondaryVariant),
              ),
            ),
          ),
          if (!_valid)
            Text(
              Translations.of(context).product_favorite_dialog_set_title_error,
              style: Theme.of(context).textTheme.bodyText1.copyWith(color: Theme.of(context).colorScheme.error),
            ),
          SizedBox(height: 50),
          TextButton(
            onPressed: () {
              _valid = _title.isNotEmpty;
              setState(() {});
              if (_valid) {
                return widget.onConfirmName(_title);
              }
            },
            style: TextButton.styleFrom(
              backgroundColor: Theme.of(context).colorScheme.secondaryVariant,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
              padding: const EdgeInsets.only(top: 18, bottom: 14),
            ),
            child: Text(
              Translations.of(context).product_favorite_dialog_next,
              style: Theme.of(context).textTheme.button.copyWith(color: BamColorPalette.bamWhite),
            ),
          ),
          SizedBox(height: 20),
          OutlinedButton(
            onPressed: widget.onTapCancel,
            style: OutlinedButton.styleFrom(
              primary: Theme.of(context).colorScheme.surface,
              side: BorderSide(color: BamColorPalette.bamBlue1Optimized),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
              padding: const EdgeInsets.only(top: 18, bottom: 14),
            ),
            child: Text(
              Translations.of(context).qrcode_product_dialog_cancel,
              style: Theme.of(context).textTheme.button.copyWith(color: BamColorPalette.bamBlue1Optimized),
            ),
          ),
        ],
      ),
    );
  }
}
