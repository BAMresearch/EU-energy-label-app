/* * Copyright 2020 Bundesanstalt für Materialforschung und -prüfung (BAM) *
* Licensed under the EUPL, Version 1.2 or – as soon they will be approved by the European Commission - subsequent versions of the EUPL (the "Licence");
* You may not use this work except in compliance with theLicence.
* You may obtain a copy of the Licence at:
* * https://joinup.ec.europa.eu/software/page/eupl *
* Unless required by applicable law or agreed to in writing, software distributed under the Licence is distributed on an "AS IS" basis,
* WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
* See the Licence for the specific language governing permissions and limitations under the Licence.*/

import 'package:energielabel_app/data/asset_paths.dart';
import 'package:energielabel_app/ui/misc/theme/bam_colors.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class BamRadioListTile extends ListTile {
  BamRadioListTile({
    @required Function(bool checked) onChanged,
    @required bool value,
    @required Text title,
    bool enabled = true,
  })  : assert(onChanged != null),
        assert(value != null),
        assert(title != null),
        _onChanged = onChanged,
        _value = value,
        _title = title,
        super(enabled: enabled);

  final Function(bool checked) _onChanged;
  final bool _value;
  final Text _title;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: enabled ? () => _onChanged(!_value) : null,
      child: Padding(
        padding: const EdgeInsets.only(top: 8, right: 0, bottom: 8),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (_value)
              SvgPicture.asset(AssetPaths.checkedIcon)
            else
              SvgPicture.asset(
                AssetPaths.uncheckedIcon,
                color: enabled ? null : BamColorPalette.bamWhite80,
              ),
            SizedBox(width: 16),
            Expanded(child: _title),
          ],
        ),
      ),
    );
  }
}
