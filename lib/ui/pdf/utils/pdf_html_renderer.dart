/* * Copyright 2020 Bundesanstalt für Materialforschung und -prüfung (BAM) *
* Licensed under the EUPL, Version 1.2 or – as soon they will be approved by the European Commission - subsequent versions of the EUPL (the "Licence");
* You may not use this work except in compliance with theLicence.
* You may obtain a copy of the Licence at:
* * https://joinup.ec.europa.eu/software/page/eupl *
* Unless required by applicable law or agreed to in writing, software distributed under the Licence is distributed on an "AS IS" basis,
* WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
* See the Licence for the specific language governing permissions and limitations under the Licence.*/

import 'package:html/dom.dart' as dom;
import 'package:pdf/widgets.dart';

typedef NodeBuilder = List<Widget> Function(dom.NodeList nodeList);
typedef TextBuilder = Widget Function(dom.NodeList nodeList);

abstract class PdfHtmlRenderer {
  Widget render(dom.Node node, NodeBuilder childAsNodeBuilder, TextBuilder childAsTextBuilder);
}

class ListsRenderer extends PdfHtmlRenderer {
  @override
  Widget render(dom.Node node, NodeBuilder childAsNodeBuilder, TextBuilder childAsTextBuilder) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: childAsNodeBuilder(node.nodes),
    );
  }
}

class LiRenderer extends PdfHtmlRenderer {
  @override
  Widget render(dom.Node node, NodeBuilder childAsNodeBuilder, TextBuilder childAsTextBuilder) {
    String elementPrefix;
    if (node.parent.localName == 'ol') {
      final index = node.parent.nodes.indexWhere((liElement) => liElement == node) + 1;
      elementPrefix = '$index.';

      if (node.parent.attributes.containsKey('type') && node.parent.attributes['type'] == 'a') {
        elementPrefix = String.fromCharCode(('a'.codeUnitAt(0)) + index - 1) + '.';
      }
    } else if (node.parent.localName == 'ul') {
      elementPrefix = '*';
    }

    return Padding(
      padding: EdgeInsets.all(8.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [Text(elementPrefix), SizedBox(width: 8), Expanded(child: childAsTextBuilder(node.nodes))],
      ),
    );
  }
}
