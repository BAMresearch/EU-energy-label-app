/* * Copyright 2020 Bundesanstalt für Materialforschung und -prüfung (BAM) *
* Licensed under the EUPL, Version 1.2 or – as soon they will be approved by the European Commission - subsequent versions of the EUPL (the "Licence");
* You may not use this work except in compliance with theLicence.
* You may obtain a copy of the Licence at:
* * https://joinup.ec.europa.eu/software/page/eupl *
* Unless required by applicable law or agreed to in writing, software distributed under the Licence is distributed on an "AS IS" basis,
* WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
* See the Licence for the specific language governing permissions and limitations under the Licence.*/

import 'dart:convert';
import 'dart:developer';

import 'package:energielabel_app/ui/know_how/components/media_error_widget.dart';
import 'package:flutter/material.dart';

class CategoryTipImageSection extends StatelessWidget {
  const CategoryTipImageSection({Key? key, required this.imageData}) : super(key: key);

  final String imageData;

  @override
  Widget build(BuildContext context) {
    if (imageData.isNotEmpty) {
      try {
        return Image.memory(
          const Base64Decoder().convert(imageData),
          fit: BoxFit.fitHeight,
          errorBuilder: _buildErrorState,
        );
      } catch (e, stacktrace) {
        return _buildErrorState(context, e, stacktrace);
      }
    }
    return const SizedBox.shrink();
  }

  Widget _buildErrorState(BuildContext context, Object error, StackTrace? stacktrace) {
    log('Failed to load image data.', error: error, stackTrace: stacktrace);
    return MediaErrorWidget.image();
  }
}
