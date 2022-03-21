/* * Copyright 2020 Bundesanstalt für Materialforschung und -prüfung (BAM) *
* Licensed under the EUPL, Version 1.2 or – as soon they will be approved by the European Commission - subsequent versions of the EUPL (the "Licence");
* You may not use this work except in compliance with theLicence.
* You may obtain a copy of the Licence at:
* * https://joinup.ec.europa.eu/software/page/eupl *
* Unless required by applicable law or agreed to in writing, software distributed under the Licence is distributed on an "AS IS" basis,
* WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
* See the Licence for the specific language governing permissions and limitations under the Licence.*/

import 'package:energielabel_app/model/know_how/label_guide/label_tip_content_image.dart';
import 'package:flutter/cupertino.dart';

class CategoryTipImageTextSection extends StatelessWidget {
  const CategoryTipImageTextSection({Key? key, required this.content}) : super(key: key);
  final LabelTipContentImage content;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          flex: 3,
          child: Image(
            image: NetworkImage(content.graphicPath!),
          ),
        ),
        const SizedBox(width: 8),
        Expanded(
          flex: 7,
          child: Text(
            content.description!,
            maxLines: null,
          ),
        ),
      ],
    );
  }
}
