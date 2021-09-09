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

class MediaErrorWidget extends StatelessWidget {
  const MediaErrorWidget._({Key? key, required _MediaType mediaType})
      : _mediaType = mediaType,
        super(key: key);

  factory MediaErrorWidget.image({Key? key}) => MediaErrorWidget._(key: key, mediaType: _MediaType.image);

  factory MediaErrorWidget.video({Key? key}) => MediaErrorWidget._(key: key, mediaType: _MediaType.video);

  final _MediaType _mediaType;

  @override
  Widget build(BuildContext context) {
    return AspectRatio(
      aspectRatio: 2 / 1,
      child: Container(
        color: BamColorPalette.bamWhite,
        margin: const EdgeInsets.symmetric(horizontal: 20),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.image_not_supported_outlined,
              color: BamColorPalette.bamBlack30,
              size: 32,
            ),
            SizedBox(height: 16),
            Text(
              _getErrorMessage(context),
              style: Theme.of(context).textTheme.subtitle2!.copyWith(color: BamColorPalette.bamBlack30),
            ),
          ],
        ),
      ),
    );
  }

  String _getErrorMessage(BuildContext context) {
    switch (_mediaType) {
      case _MediaType.image:
        return Translations.of(context)!.error_image_loading;
      case _MediaType.video:
        return Translations.of(context)!.error_video_loading;
      default:
        throw ArgumentError.value(_mediaType);
    }
  }
}

enum _MediaType { image, video }
