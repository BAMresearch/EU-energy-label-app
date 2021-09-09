/* * Copyright 2020 Bundesanstalt für Materialforschung und -prüfung (BAM) *
* Licensed under the EUPL, Version 1.2 or – as soon they will be approved by the European Commission - subsequent versions of the EUPL (the "Licence");
* You may not use this work except in compliance with theLicence.
* You may obtain a copy of the Licence at:
* * https://joinup.ec.europa.eu/software/page/eupl *
* Unless required by applicable law or agreed to in writing, software distributed under the Licence is distributed on an "AS IS" basis,
* WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
* See the Licence for the specific language governing permissions and limitations under the Licence.*/

import 'package:energielabel_app/ui/misc/components/bam_dialog.dart';
import 'package:energielabel_app/ui/misc/components/bam_radio_list_tile.dart';
import 'package:energielabel_app/ui/misc/theme/bam_colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/translations.dart';

enum FavoriteExportDialogVisualState { selection, loading }

class FavoriteExportDialog extends StatefulWidget {
  const FavoriteExportDialog({
    required Future<void> Function({bool? productsChecked, bool? knowHowChecked}) onExportConfirmed,
    VoidCallback? onExportDeclined,
    FavoriteExportDialogVisualState initialDialogState = FavoriteExportDialogVisualState.selection,
    this.isProductsEmpty = false,
    this.isKnowHowEmpty = false,
  })  : _initialDialogState = initialDialogState,
        _onExportConfirmed = onExportConfirmed,
        _onExportDeclined = onExportDeclined;

  final FavoriteExportDialogVisualState _initialDialogState;
  final Future<void> Function({bool? productsChecked, bool? knowHowChecked}) _onExportConfirmed;
  final VoidCallback? _onExportDeclined;
  final bool isProductsEmpty;
  final bool isKnowHowEmpty;

  @override
  State<StatefulWidget> createState() => _FavoriteExportDialogState();
}

class _FavoriteExportDialogState extends State<FavoriteExportDialog> {
  bool _isProductsChecked = false;
  bool _isKnowHowChecked = false;

  FavoriteExportDialogVisualState _dialogState = FavoriteExportDialogVisualState.selection;

  @override
  void initState() {
    _dialogState = widget._initialDialogState;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return BamDialog.widget(
      title: Translations.of(context)!.favorites_page_export_dialog_title,
      confirmButtonText: _dialogState == FavoriteExportDialogVisualState.selection
          ? Translations.of(context)!.favorites_page_export_dialog_export_button
          : null,
      onPressConfirm: _dialogState == FavoriteExportDialogVisualState.selection &&
              (_isKnowHowChecked || _isProductsChecked)
          ? () async {
              setState(() {
                _dialogState = FavoriteExportDialogVisualState.loading;
              });
              await widget._onExportConfirmed(productsChecked: _isProductsChecked, knowHowChecked: _isKnowHowChecked);
              Navigator.of(context).pop();
            }
          : null,
      denyButtonText: _dialogState == FavoriteExportDialogVisualState.selection
          ? Translations.of(context)!.favorites_page_export_dialog_cancel_button
          : null,
      onPressDeny: _dialogState == FavoriteExportDialogVisualState.selection
          ? () {
              widget._onExportDeclined?.call();
              Navigator.of(context).pop();
            }
          : null,
      child: _dialogState == FavoriteExportDialogVisualState.selection
          ? _buildSelectionState(context)
          : _buildLoadingState(),
    );
  }

  Widget _buildSelectionState(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(Translations.of(context)!.favorites_page_export_dialog_hint),
          SizedBox(height: 24),
          BamRadioListTile(
            value: _isProductsChecked,
            onChanged: (isChecked) {
              setState(() {
                _isProductsChecked = !_isProductsChecked;
              });
            },
            title: Text(
              Translations.of(context)!.favorites_page_export_dialog_products_checkbox,
              style: Theme.of(context).textTheme.bodyText2!.copyWith(
                  color: widget.isProductsEmpty ? BamColorPalette.bamBlack45Optimized : BamColorPalette.bamBlack),
            ),
            enabled: !widget.isProductsEmpty,
          ),
          BamRadioListTile(
            value: _isKnowHowChecked,
            onChanged: (isChecked) {
              setState(() {
                _isKnowHowChecked = !_isKnowHowChecked;
              });
            },
            title: Text(
              Translations.of(context)!.favorites_page_export_dialog_know_how_checkbox,
              style: Theme.of(context).textTheme.bodyText2!.copyWith(
                  color: widget.isKnowHowEmpty ? BamColorPalette.bamBlack45Optimized : BamColorPalette.bamBlack),
            ),
            enabled: !widget.isKnowHowEmpty,
          ),
        ],
      ),
    );
  }

  Widget _buildLoadingState() {
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Text(Translations.of(context)!.favorites_page_export_dialog_loading_hint),
        SizedBox(
          height: 16,
        ),
        CircularProgressIndicator(),
      ],
    );
  }
}
