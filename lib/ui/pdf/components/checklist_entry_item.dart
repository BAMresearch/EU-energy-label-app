/* * Copyright 2020 Bundesanstalt für Materialforschung und -prüfung (BAM) *
* Licensed under the EUPL, Version 1.2 or – as soon they will be approved by the European Commission - subsequent versions of the EUPL (the "Licence");
* You may not use this work except in compliance with theLicence.
* You may obtain a copy of the Licence at:
* * https://joinup.ec.europa.eu/software/page/eupl *
* Unless required by applicable law or agreed to in writing, software distributed under the Licence is distributed on an "AS IS" basis,
* WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
* See the Licence for the specific language governing permissions and limitations under the Licence.*/

import 'package:energielabel_app/data/asset_paths.dart';
import 'package:energielabel_app/model/know_how/label_guide/checklist_entry.dart';
import 'package:energielabel_app/ui/pdf/resources/svg_asset.dart';
import 'package:pdf/widgets.dart';

class ChecklistEntryItem extends StatelessWidget {
  ChecklistEntryItem(this.entry);

  final ChecklistEntry entry;

  @override
  Widget build(Context context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SvgImage(
            svg: entry.checked!
                ? SvgAsset.getSvgString(context, AssetPaths.checkedIcon)!
                : SvgAsset.getSvgString(context, AssetPaths.uncheckedIcon)!,
          ),
          SizedBox(width: 16),
          Expanded(child: Text(entry.text!)),
        ],
      ),
    );
  }
}
