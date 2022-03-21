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
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:flutter_gen/gen_l10n/translations.dart';

class BamRadioListTile extends ListTile {
  const BamRadioListTile({
    Key? key,
    required Function(bool checked) onChanged,
    required bool value,
    required Text title,
    bool enabled = true,
  })  : _onChanged = onChanged,
        _value = value,
        _title = title,
        super(key: key, enabled: enabled);

  final Function(bool checked) _onChanged;
  final bool _value;
  final Text _title;

  @override
  Widget build(BuildContext context) {
    return Semantics(
      button: true,
      hint: _value
          ? Translations.of(context)!.know_how_checklist_selected_semantics_hint
          : Translations.of(context)!.know_how_checklist_deselected_semantics_hint,
      label: _value
          ? Translations.of(context)!.know_how_checklist_selected_semantics(_title.data ?? '')
          : Translations.of(context)!.know_how_checklist_deselected_semantics(_title.data ?? ''),
      excludeSemantics: true,
      child: InkWell(
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
              const SizedBox(width: 16),
              Expanded(child: _title),
            ],
          ),
        ),
      ),
    );
  }
}
