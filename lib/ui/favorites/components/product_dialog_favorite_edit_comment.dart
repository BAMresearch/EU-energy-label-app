/* * Copyright 2020 Bundesanstalt für Materialforschung und -prüfung (BAM) *
* Licensed under the EUPL, Version 1.2 or – as soon they will be approved by the European Commission - subsequent versions of the EUPL (the "Licence");
* You may not use this work except in compliance with theLicence.
* You may obtain a copy of the Licence at:
* * https://joinup.ec.europa.eu/software/page/eupl *
* Unless required by applicable law or agreed to in writing, software distributed under the Licence is distributed on an "AS IS" basis,
* WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
* See the Licence for the specific language governing permissions and limitations under the Licence.*/

import 'package:energielabel_app/model/favorite.dart';
import 'package:energielabel_app/ui/misc/components/bam_dialog.dart';
import 'package:energielabel_app/ui/misc/theme/bam_colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/translations.dart';

enum CurrentDialogState { comment, productName }

class ProductDialogFavoriteEditComment extends StatefulWidget {
  const ProductDialogFavoriteEditComment({
    Key? key,
    required this.onFinish,
    required this.product,
  }) : super(key: key);

  final Function(String comment, String title) onFinish;
  final ProductFavorite product;

  @override
  _ProductDialogFavoriteEditCommentState createState() => _ProductDialogFavoriteEditCommentState();
}

class _ProductDialogFavoriteEditCommentState extends State<ProductDialogFavoriteEditComment> {
  CurrentDialogState _currentDialogState = CurrentDialogState.productName;
  late String _comment;
  late String _name;

  @override
  void initState() {
    _comment = widget.product.comments?.first ?? '';
    _name = widget.product.title ?? '';
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return BamDialog.custom(
      title: _currentDialogState == CurrentDialogState.productName
          ? Translations.of(context)!.product_favorite_dialog_edit_name
          : Translations.of(context)!.product_favorite_dialog_edit_comment,
      isScrollable: true,
      builder: (context) => Padding(
        padding: const EdgeInsets.fromLTRB(48, 16, 48, 40),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            TextField(
              maxLines: 3,
              keyboardType: TextInputType.multiline,
              controller:
                  TextEditingController(text: _currentDialogState == CurrentDialogState.productName ? _name : _comment),
              autofocus: false,
              onChanged: (String input) {
                if (_currentDialogState == CurrentDialogState.productName) {
                  _name = input;
                } else {
                  _comment = input;
                }
              },
              decoration: InputDecoration(
                hintText: Translations.of(context)!.product_favorite_dialog_add_comment_hint,
                enabledBorder: const OutlineInputBorder(),
                focusedBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: Theme.of(context).colorScheme.secondaryContainer),
                ),
              ),
            ),
            const SizedBox(height: 50),
            _buildActionButton(context),
            const SizedBox(height: 20),
            _buildCancelButton(context),
          ],
        ),
      ),
    );
  }

  Widget _buildCancelButton(BuildContext context) {
    return OutlinedButton(
      onPressed: () {
        Navigator.pop(context);
      }, // widget.onTapCancel,
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
    );
  }

  Widget _buildActionButton(BuildContext context) {
    return TextButton(
      onPressed: () {
        if (_currentDialogState == CurrentDialogState.productName) {
          _currentDialogState = CurrentDialogState.comment;
          setState(() {});
        } else {
          widget.onFinish(_comment, _name);
        }
      },
      style: TextButton.styleFrom(
        backgroundColor: Theme.of(context).colorScheme.secondaryContainer,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
        padding: const EdgeInsets.only(top: 18, bottom: 14),
      ),
      child: Text(
        _currentDialogState == CurrentDialogState.productName
            ? Translations.of(context)!.product_favorite_dialog_next
            : Translations.of(context)!.product_favorite_dialog_confirmation_button,
        style: Theme.of(context).textTheme.button!.copyWith(color: BamColorPalette.bamWhite),
      ),
    );
  }
}
