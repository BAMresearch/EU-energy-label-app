/* * Copyright 2020 Bundesanstalt für Materialforschung und -prüfung (BAM) *
* Licensed under the EUPL, Version 1.2 or – as soon they will be approved by the European Commission - subsequent versions of the EUPL (the "Licence");
* You may not use this work except in compliance with theLicence.
* You may obtain a copy of the Licence at:
* * https://joinup.ec.europa.eu/software/page/eupl *
* Unless required by applicable law or agreed to in writing, software distributed under the Licence is distributed on an "AS IS" basis,
* WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
* See the Licence for the specific language governing permissions and limitations under the Licence.*/

import 'package:energielabel_app/ui/misc/theme/bam_colors.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class RadioButton<T> extends StatefulWidget {
  RadioButton({
    Key key,
    @required this.value,
    @required this.caption,
    @required this.onChanged,
    this.groupValue,
  })  : assert(value != null),
        assert(caption != null),
        assert(onChanged != null),
        super(key: key);

  final T value;
  final T groupValue;
  final String caption;
  final Function onChanged;

  @override
  State<StatefulWidget> createState() => _RadioButtonState();
}

class _RadioButtonState extends State<RadioButton> {
  @override
  Widget build(BuildContext context) {
    final bool selected = widget.value == widget.groupValue;

    return GestureDetector(
      onTap: () {
        widget.onChanged(widget.value);
      },
      child: Container(
        width: double.maxFinite,
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(8),
            color: selected ? BamColorPalette.bamBlack80 : BamColorPalette.bamWhite),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Text(
            widget.caption,
            textAlign: TextAlign.center,
            style: Theme.of(context)
                .textTheme
                .button
                .copyWith(color: selected ? BamColorPalette.bamWhite : BamColorPalette.bamBlack80),
          ),
        ),
      ),
    );
  }
}
