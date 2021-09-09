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
import 'package:flutter_svg/flutter_svg.dart';

class ItemButton extends StatelessWidget {
  const ItemButton({
    Key? key,
    required this.label,
    required this.iconAssetPath,
    required this.onTap,
  }) : super(key: key);

  final String label;
  final String iconAssetPath;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: onTap,
      style: ButtonStyle(
          elevation: MaterialStateProperty.all(0),
          overlayColor: MaterialStateProperty.all(BamColorPalette.bamBlack10),
          backgroundColor: MaterialStateProperty.all(Theme.of(context).colorScheme.surface),
          shape: MaterialStateProperty.all(RoundedRectangleBorder(borderRadius: BorderRadius.circular(8))),
          padding: MaterialStateProperty.all(EdgeInsets.all(16))),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Expanded(
            flex: 8,
            child: Text(
              label,
              style: Theme.of(context).textTheme.bodyText2!.copyWith(color: BamColorPalette.bamBlue3),
            ),
          ),
          Expanded(
            flex: 2,
            child: SvgPicture.asset(iconAssetPath, color: BamColorPalette.bamBlue3, height: 30),
          ),
        ],
      ),
    );
  }
}
