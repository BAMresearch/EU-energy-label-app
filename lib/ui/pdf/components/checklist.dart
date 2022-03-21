/* * Copyright 2020 Bundesanstalt für Materialforschung und -prüfung (BAM) *
* Licensed under the EUPL, Version 1.2 or – as soon they will be approved by the European Commission - subsequent versions of the EUPL (the "Licence");
* You may not use this work except in compliance with theLicence.
* You may obtain a copy of the Licence at:
* * https://joinup.ec.europa.eu/software/page/eupl *
* Unless required by applicable law or agreed to in writing, software distributed under the Licence is distributed on an "AS IS" basis,
* WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
* See the Licence for the specific language governing permissions and limitations under the Licence.*/

import 'package:energielabel_app/model/know_how/label_guide/label_category_checklist.dart';
import 'package:energielabel_app/ui/misc/theme/bam_colors.dart';
import 'package:energielabel_app/ui/pdf/components/checklist_entry_item.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart';

class Checklist extends StatelessWidget {
  Checklist(this.checklist);

  final LabelCategoryChecklist checklist;

  @override
  Widget build(Context context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 8),
            child: Text(checklist.title!, style: Theme.of(context).header2),
          ),
          for (final checklistEntry in checklist.checklistEntries!) ChecklistEntryItem(checklistEntry),
          SizedBox(height: 8),
          Divider(color: PdfColor.fromInt(BamColorPalette.bamBlack10.value)),
        ],
      ),
    );
  }
}
