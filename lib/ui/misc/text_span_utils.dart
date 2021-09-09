/* * Copyright 2020 Bundesanstalt für Materialforschung und -prüfung (BAM) *
* Licensed under the EUPL, Version 1.2 or – as soon they will be approved by the European Commission - subsequent versions of the EUPL (the "Licence");
* You may not use this work except in compliance with theLicence.
* You may obtain a copy of the Licence at:
* * https://joinup.ec.europa.eu/software/page/eupl *
* Unless required by applicable law or agreed to in writing, software distributed under the Licence is distributed on an "AS IS" basis,
* WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
* See the Licence for the specific language governing permissions and limitations under the Licence.*/

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

extension TextSpanExtension on TextSpan {
  static TextSpan searchMatch(
    String? match,
    String search, {
    TextStyle negativeResultTextStyle = const TextStyle(color: Colors.black),
    TextStyle positiveResultTextStyle = const TextStyle(color: Colors.blue),
  }) {
    if (search.isEmpty) {
      return TextSpan(text: match, style: negativeResultTextStyle);
    }
    final refinedMatch = match!.toLowerCase();
    final refinedSearch = search.toLowerCase();
    if (refinedMatch.contains(refinedSearch)) {
      if (refinedMatch.substring(0, refinedSearch.length) == refinedSearch) {
        return TextSpan(
          style: positiveResultTextStyle,
          text: match.substring(0, refinedSearch.length),
          children: [
            searchMatch(
                match.substring(
                  refinedSearch.length,
                ),
                search,
                negativeResultTextStyle: negativeResultTextStyle,
                positiveResultTextStyle: positiveResultTextStyle),
          ],
        );
      } else if (refinedMatch.length == refinedSearch.length) {
        return TextSpan(text: match, style: positiveResultTextStyle);
      } else {
        return TextSpan(
          style: negativeResultTextStyle,
          text: match.substring(
            0,
            refinedMatch.indexOf(refinedSearch),
          ),
          children: [
            searchMatch(
                match.substring(
                  refinedMatch.indexOf(refinedSearch),
                ),
                search,
                negativeResultTextStyle: negativeResultTextStyle,
                positiveResultTextStyle: positiveResultTextStyle),
          ],
        );
      }
    } else if (!refinedMatch.contains(refinedSearch)) {
      return TextSpan(text: match, style: negativeResultTextStyle);
    }
    return TextSpan(
      text: match.substring(0, refinedMatch.indexOf(refinedSearch)),
      style: negativeResultTextStyle,
      children: [
        searchMatch(match.substring(refinedMatch.indexOf(refinedSearch)), search,
            negativeResultTextStyle: negativeResultTextStyle, positiveResultTextStyle: positiveResultTextStyle)
      ],
    );
  }
}
