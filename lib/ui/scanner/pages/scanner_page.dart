/* * Copyright 2020 Bundesanstalt für Materialforschung und -prüfung (BAM) *
* Licensed under the EUPL, Version 1.2 or – as soon they will be approved by the European Commission - subsequent versions of the EUPL (the "Licence");
* You may not use this work except in compliance with theLicence.
* You may obtain a copy of the Licence at:
* * https://joinup.ec.europa.eu/software/page/eupl *
* Unless required by applicable law or agreed to in writing, software distributed under the Licence is distributed on an "AS IS" basis,
* WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
* See the Licence for the specific language governing permissions and limitations under the Licence.*/

import 'dart:async';
import 'dart:io';

import 'package:energielabel_app/ui/misc/components/bam_dialog.dart';
import 'package:energielabel_app/ui/misc/page_scaffold.dart';
import 'package:energielabel_app/ui/misc/pages/base_page.dart';
import 'package:energielabel_app/ui/scanner/components/scanner_overlay_shape.dart';
import 'package:energielabel_app/ui/scanner/pages/scanner_view_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_fimber/flutter_fimber.dart';
import 'package:flutter_gen/gen_l10n/translations.dart';
import 'package:qr_code_scanner/qr_code_scanner.dart';
import 'package:visibility_detector/visibility_detector.dart';

class ScannerPage extends StatefulPage {
  @override
  _ScannerPageState createPageState() => _ScannerPageState();
}

class _ScannerPageState extends PageState<ScannerPage, ScannerViewModel> with WidgetsBindingObserver {
  final GlobalKey _qrViewKey = GlobalKey();
  QRViewController? _qrViewController;
  late ScannerViewModel _viewModel;
  bool _ignoreScannerEvents = false;

  @override
  void initState() {
    _viewModel = createViewModel(context);
    scheduleMicrotask(() => _viewModel.onViewStarted());
    super.initState();
    WidgetsBinding.instance!.addObserver(this);
  }

  @override
  ScannerViewModel createViewModel(BuildContext context) {
    return ScannerViewModel(context: context);
  }

  // In order to get hot reload to work we need to pause the camera if the platform
  // is android, or resume the camera if the platform is iOS.
  @override
  void reassemble() {
    super.reassemble();
    if (Platform.isAndroid) {
      _qrViewController!.pauseCamera();
    }
    Fimber.i('resumeCamera(): CALLED');
    _qrViewController!.resumeCamera();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (_qrViewController != null && _qrViewController!.hasPermissions) {
      if (state == AppLifecycleState.paused) {
        _pauseScanner();
      } else if (state == AppLifecycleState.resumed) {
        _resumeScanner();
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final overlayColor = Theme.of(context).colorScheme.surface;
    final overlayOpacity = 0.7;
    final overlayOpacityGradient = 0.49;
    final cutOutSize = 230.0;

    return PageScaffold(
      title: Translations.of(context)!.qrcode_page_title,
      body: VisibilityDetector(
        key: ValueKey('Scanner-Visibility-Detector'),
        onVisibilityChanged: _onVisibilityChanged,
        child: Stack(
          children: [
            QRView(
              key: _qrViewKey,
              onQRViewCreated: _onQRViewCreated,
              onPermissionSet: _onPermissionSet,
            ),
            Column(
              children: [
                Expanded(
                  flex: 2,
                  child: Container(
                    decoration: ShapeDecoration(
                      shape: QrScannerOverlayShape(
                        overlayColor: overlayColor.withOpacity(overlayOpacity),
                        borderWidth: 16,
                        borderLength: 60,
                        borderRadius: 1,
                        cutOutSize: cutOutSize,
                        borderColor: Theme.of(context).colorScheme.onPrimary,
                      ),
                    ),
                  ),
                ),
                // Actually, the size of the shape below should be measured and
                // positioned by a Flexible, but due to:
                // https://github.com/flutter/flutter/issues/14288
                // there is a bug in the calculation when AntiAliasing is applied.
                // Hence, a SizedBox is used, which constraints to a manually calculated
                // and non-fractional height. While the height stays without any
                // fractional numbers, no AntiAliasing is applied and the bug is
                // omitted. The positioning should be the same as with a Flexible (+/- 5px).
                // Eventually, when the bug is fixed, this workaround can be changed back
                // to using a Flexible instead of a wrapping SizedBox.
                // https://issues.init.de/browse/BAMENERGIE-107
                SizedBox(
                  height: (MediaQuery.of(context).size.height * 0.23).ceilToDouble(),
                  child: DecoratedBox(
                    decoration: ShapeDecoration(
                        shape: ScannerOverlayShape(overlayColor: overlayColor, opacity: overlayOpacityGradient)),
                    child: SizedBox.expand(),
                  ),
                ),
              ],
            ),
            Align(
              alignment: Alignment(0, 0.8),
              child: SizedBox(
                width: cutOutSize + 50,
                child: Padding(
                  padding: const EdgeInsets.all(24.0),
                  child: Text(
                    Translations.of(context)!.scanner_instructions,
                    textAlign: TextAlign.center,
                    style: Theme.of(context).textTheme.subtitle1,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    _qrViewController!.dispose();
    _viewModel.dispose();
    WidgetsBinding.instance!.removeObserver(this);
    super.dispose();
  }

  void _onPermissionSet(QRViewController controller, bool permission) {
    Fimber.i('Camera Permission: $permission');
  }

  void _onQRViewCreated(QRViewController qrViewController) {
    setState(() {
      _qrViewController = qrViewController;
    });

    // When a scan result comes in pause the camera and ignore the following events
    // until the user closed the dialog or comes back from the details page.
    _qrViewController!.scannedDataStream
        .where((_) => !_ignoreScannerEvents)
        .where((scanResult) => scanResult.format == BarcodeFormat.qrcode)
        .listen(
      (scanResult) async {
        // await _pauseScanner(); // Is needed in order to resume camera on pushReplacement
        _qrViewController!.dispose();
        if (!_viewModel.isDialogOpen) {
          _viewModel.onScanResult(scanResult.code.toLowerCase(), _onQRCodeInvalid, () {
            Navigator.pushReplacementNamed(context, '/');
          });
        }
      },
    );
  }

  void _onVisibilityChanged(VisibilityInfo visibilityInfo) {
    if (visibilityInfo.visibleFraction == 1) {
      _resumeScanner();
    } else {
      _pauseScanner();
    }
  }

  Future<void> _onQRCodeInvalid() async {
    await showDialogWithBlur(
      context: context,
      builder: (context) {
        return BamDialog.message(
          title: Translations.of(context)!.qrcode_invalid_dialog_title,
          message: Translations.of(context)!.qrcode_invalid_dialog_message,
          confirmButtonText: Translations.of(context)!.qrcode_invalid_dialog_button,
          onPressConfirm: () {
            Navigator.of(context).pop();
            Navigator.pushReplacementNamed(this.context, '/'); // this is needed to get the right tab navigation context
          },
        );
      },
    );
  }

  Future<void> _pauseScanner() async {
    Fimber.i('pauseCamera(): CALLED');
    await _qrViewController!.pauseCamera();
    _ignoreScannerEvents = true;
  }

  Future<void> _resumeScanner() async {
    if (_qrViewController == null) {
      return;
    }

    if (_viewModel.isDialogOpen) {
      Fimber.i('Dialog open! You cannot resume camera now!');
      return;
    }

    Fimber.i('resumeCamera(): CALLED');
    await _qrViewController!.resumeCamera();
    _ignoreScannerEvents = false;
  }
}
