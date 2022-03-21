/* * Copyright 2020 Bundesanstalt für Materialforschung und -prüfung (BAM) *
* Licensed under the EUPL, Version 1.2 or – as soon they will be approved by the European Commission - subsequent versions of the EUPL (the "Licence");
* You may not use this work except in compliance with theLicence.
* You may obtain a copy of the Licence at:
* * https://joinup.ec.europa.eu/software/page/eupl *
* Unless required by applicable law or agreed to in writing, software distributed under the Licence is distributed on an "AS IS" basis,
* WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
* See the Licence for the specific language governing permissions and limitations under the Licence.*/

import 'package:flutter/material.dart';

class MultiCrossFadeAnimation extends StatelessWidget {
  const MultiCrossFadeAnimation({
    Key? key,
    required this.children,
    this.visibleWidgetIndex = 0,
    this.duration = const Duration(milliseconds: 300),
    this.curve = Curves.linear,
  }) : super(key: key);

  final List<Widget> children;
  final int visibleWidgetIndex;
  final Duration duration;
  final Curve curve;

  static const double _visibleOpacity = 1.0;
  static const double _hiddenOpacity = 0.0;

  @override
  Widget build(BuildContext context) {
    final List<Widget> _animatedWidgets = [];
    for (var index = 0; index < children.length; index++) {
      _animatedWidgets.add(AnimatedOpacity(
        curve: curve,
        duration: duration,
        opacity: index == visibleWidgetIndex ? _visibleOpacity : _hiddenOpacity,
        child: children[index],
      ));
    }

    return Stack(
      fit: StackFit.expand,
      children: _animatedWidgets,
    );
  }
}
