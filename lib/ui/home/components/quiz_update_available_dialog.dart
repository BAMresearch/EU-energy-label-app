/* * Copyright 2020 Bundesanstalt für Materialforschung und -prüfung (BAM) *
* Licensed under the EUPL, Version 1.2 or – as soon they will be approved by the European Commission - subsequent versions of the EUPL (the "Licence");
* You may not use this work except in compliance with theLicence.
* You may obtain a copy of the Licence at:
* * https://joinup.ec.europa.eu/software/page/eupl *
* Unless required by applicable law or agreed to in writing, software distributed under the Licence is distributed on an "AS IS" basis,
* WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
* See the Licence for the specific language governing permissions and limitations under the Licence.*/

import 'package:energielabel_app/ui/misc/components/bam_dialog.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/translations.dart';

class QuizUpdateAvailableDialog extends StatelessWidget {
  const QuizUpdateAvailableDialog({
    required this.onQuizUpdateConfirmed,
    required this.onQuizUpdateDeclined,
  });

  final VoidCallback onQuizUpdateConfirmed;
  final VoidCallback onQuizUpdateDeclined;

  @override
  Widget build(BuildContext context) {
    return BamDialog.message(
      title: Translations.of(context)!.quiz_update_available_dialog_title,
      message: Translations.of(context)!.quiz_update_available_dialog_message,
      denyButtonText: Translations.of(context)!.quiz_update_available_dialog_cancel_button,
      onPressDeny: () {
        onQuizUpdateDeclined();
        Navigator.of(context).pop();
      },
      confirmButtonText: Translations.of(context)!.quiz_update_available_dialog_update_button,
      onPressConfirm: () {
        onQuizUpdateConfirmed();
        Navigator.of(context).pop();
      },
    );
  }
}
