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

class ProductDialogFavoriteAddComment extends StatefulWidget {
  const ProductDialogFavoriteAddComment({
    Key? key,
    required this.onAddComment,
    required this.onTapCancel,
    required this.onConfirm,
  }) : super(key: key);

  final Function(String name) onAddComment;
  final VoidCallback onTapCancel;
  final VoidCallback onConfirm;

  @override
  _ProductDialogFavoriteAddCommentState createState() => _ProductDialogFavoriteAddCommentState();
}

class _ProductDialogFavoriteAddCommentState extends State<ProductDialogFavoriteAddComment> {
  String _comment = '';

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(48, 16, 48, 40),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          TextField(
            maxLines: 3,
            keyboardType: TextInputType.multiline,
            autofocus: false,
            onChanged: (String input) => setState(() => _comment = input),
            decoration: InputDecoration(
              hintText: Translations.of(context)!.product_favorite_dialog_add_comment_hint,
              enabledBorder: const OutlineInputBorder(),
              focusedBorder: OutlineInputBorder(
                borderSide: BorderSide(color: Theme.of(context).colorScheme.secondaryContainer),
              ),
            ),
          ),
          const SizedBox(height: 50),
          TextButton(
            onPressed: () {
              if (_comment.isNotEmpty) {
                widget.onAddComment(_comment);
              } else {
                widget.onConfirm();
              }
            },
            style: TextButton.styleFrom(
              backgroundColor: Theme.of(context).colorScheme.secondaryContainer,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
              padding: const EdgeInsets.only(top: 18, bottom: 14),
            ),
            child: Text(
              Translations.of(context)!.product_favorite_dialog_confirmation_button,
              style: Theme.of(context).textTheme.button!.copyWith(color: BamColorPalette.bamWhite),
            ),
          ),
          const SizedBox(height: 20),
          OutlinedButton(
            onPressed: widget.onTapCancel,
            style: OutlinedButton.styleFrom(
              primary: Theme.of(context).colorScheme.surface,
              side: const BorderSide(color: BamColorPalette.bamBlue1Optimized),
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
