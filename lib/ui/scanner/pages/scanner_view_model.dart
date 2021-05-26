/* * Copyright 2020 Bundesanstalt für Materialforschung und -prüfung (BAM) *
* Licensed under the EUPL, Version 1.2 or – as soon they will be approved by the European Commission - subsequent versions of the EUPL (the "Licence");
* You may not use this work except in compliance with theLicence.
* You may obtain a copy of the Licence at:
* * https://joinup.ec.europa.eu/software/page/eupl *
* Unless required by applicable law or agreed to in writing, software distributed under the Licence is distributed on an "AS IS" basis,
* WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
* See the Licence for the specific language governing permissions and limitations under the Licence.*/

import 'dart:async';

import 'package:energielabel_app/model/scanner/product.dart';
import 'package:energielabel_app/ui/favorites/favorites_routes.dart';
import 'package:energielabel_app/ui/favorites/favorites_tab_specification.dart';
import 'package:energielabel_app/ui/misc/components/bam_dialog.dart';
import 'package:energielabel_app/ui/misc/pages/base_view_model.dart';
import 'package:energielabel_app/ui/misc/tab_scaffold.dart';
import 'package:energielabel_app/ui/scanner/components/product_dialog.dart';
import 'package:energielabel_app/ui/scanner/components/product_dialog_view_model.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_fimber/flutter_fimber.dart';

class ScannerViewModel extends BaseViewModel {
  ScannerViewModel({@required BuildContext context})
      : assert(context != null),
        _context = context;

  final BuildContext _context;
  bool _dialogOpen = false;

  bool get isDialogOpen => _dialogOpen;

  @override
  FutureOr<void> onViewStarted() {}

  void onScanResult(String scanResult, Function onInvalidQrCode, Function onFinish) {
    assert(scanResult != null);

    Fimber.i('OPEN SCAN DIALOG');
    if (_isValidUrl(scanResult)) {
      _dialogOpen = true;
      showDialogWithBlur(
        context: _context,
        builder: (context) => ProductDialog(
          product: Product(url: scanResult),
          onFinish: (ProductDialogFinishAction action) {
            _dialogOpen = false;
            if (action == ProductDialogFinishAction.favorite) {
              TabScaffold.of(_context).navigateIntoTab(FavoritesTabSpecification, FavoritesRoutes.root);
            }
            onFinish();
          },
        ),
      );
    } else {
      onInvalidQrCode?.call();
    }
  }

  bool _isValidUrl(String url) {
    final regEx = RegExp(r'^(https:\/\/eprel.ec.europa.eu\/qr\/)+\d{1,12}$');
    return regEx.hasMatch(url);
  }
}
