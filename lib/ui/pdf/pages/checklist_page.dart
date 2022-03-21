/* * Copyright 2020 Bundesanstalt für Materialforschung und -prüfung (BAM) *
* Licensed under the EUPL, Version 1.2 or – as soon they will be approved by the European Commission - subsequent versions of the EUPL (the "Licence");
* You may not use this work except in compliance with theLicence.
* You may obtain a copy of the Licence at:
* * https://joinup.ec.europa.eu/software/page/eupl *
* Unless required by applicable law or agreed to in writing, software distributed under the Licence is distributed on an "AS IS" basis,
* WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
* See the Licence for the specific language governing permissions and limitations under the Licence.*/

import 'package:energielabel_app/model/know_how/label_guide/label_category_checklist_data.dart';
import 'package:energielabel_app/ui/pdf/bam_page.dart';
import 'package:energielabel_app/ui/pdf/components/checklist.dart';
import 'package:energielabel_app/ui/pdf/components/general_info_box.dart';
import 'package:pdf/widgets.dart';

class ChecklistPage extends StatelessMultiPage {
  ChecklistPage({required this.checklistData});

  final LabelCategoryChecklistData checklistData;

  @override
  List<Widget> build() {
    return [
      _ChecklistHeader(checklistData.title, checklistData.introText),
      for (final checklist in checklistData.checklists!) Checklist(checklist),
      GeneralInfoBox(title: checklistData.informationTitle, content: checklistData.informationText!),
    ];
  }
}

class _ChecklistHeader extends StatelessWidget {
  _ChecklistHeader(this.title, this.introText);

  final String? title;
  final String? introText;

  @override
  Widget build(Context context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 16),
            child: Text(title!, style: Theme.of(context).header0),
          ),
          Text(introText!),
        ],
      ),
    );
  }
}
