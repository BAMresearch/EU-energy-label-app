/* * Copyright 2020 Bundesanstalt für Materialforschung und -prüfung (BAM) *
* Licensed under the EUPL, Version 1.2 or – as soon they will be approved by the European Commission - subsequent versions of the EUPL (the "Licence");
* You may not use this work except in compliance with theLicence.
* You may obtain a copy of the Licence at:
* * https://joinup.ec.europa.eu/software/page/eupl *
* Unless required by applicable law or agreed to in writing, software distributed under the Licence is distributed on an "AS IS" basis,
* WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
* See the Licence for the specific language governing permissions and limitations under the Licence.*/

import 'dart:io';

import 'package:energielabel_app/ui/misc/pages/base_view_model.dart';
import 'package:energielabel_app/ui/misc/pages/pdf_view_page.dart';
import 'package:energielabel_app/ui/misc/pages/view_state.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/services.dart';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:share/share.dart';

class PdfViewViewModel extends BaseViewModel {
  PdfViewViewModel({
    required String pdfPath,
    required PathType pathType,
    required AssetBundle assetBundle,
    required GlobalKey shareButtonKey,
  })   : _pdfAssetPath = pdfPath,
        _pathType = pathType,
        _assetBundle = assetBundle,
        _shareButtonKey = shareButtonKey;

  final String _pdfAssetPath;
  final PathType _pathType;
  final AssetBundle _assetBundle;
  final GlobalKey _shareButtonKey;

  ViewState _viewState = ViewState.uninitialized;
  String? _contentUrl;

  ViewState get viewState => _viewState;

  String? get contentUrl => _contentUrl;

  @override
  void onViewStarted() {
    _viewState = ViewState.initializing;
    notifyListeners();

    _contentUrl = _pdfAssetPath;
    notifyListeners();
  }

  void onContentLoaded() {
    _viewState = ViewState.initialized;
    notifyListeners();
  }

  void onPdfError(dynamic error) {
    _viewState = ViewState.error;
    notifyListeners();
  }

  void onShareContent(BuildContext context) async {
    String sharePath;
    if (_pathType == PathType.assetPath) {
      final directory = (await getTemporaryDirectory());

      final data = await _assetBundle.load(_pdfAssetPath);
      final List<int> bytes = data.buffer.asUint8List(data.offsetInBytes, data.lengthInBytes);

      sharePath = join(directory.path, _pdfAssetPath.split('/').last);
      await File(sharePath).writeAsBytes(bytes);
    } else {
      sharePath = _pdfAssetPath;
    }

    await Share.shareFiles(
      [sharePath],
      sharePositionOrigin: _shareButtonRect(),
    );
  }

  Rect? _shareButtonRect() {
    final RenderBox? renderBox = _shareButtonKey.currentContext?.findRenderObject() as RenderBox?;
    if (renderBox == null) return null;

    final Size size = renderBox.size;
    final Offset position = renderBox.localToGlobal(Offset.zero);

    return Rect.fromCenter(
      center: position + Offset(size.width / 2, size.height / 2),
      width: size.width,
      height: size.height,
    );
  }
}
