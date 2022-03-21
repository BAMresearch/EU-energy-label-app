/* * Copyright 2020 Bundesanstalt für Materialforschung und -prüfung (BAM) *
* Licensed under the EUPL, Version 1.2 or – as soon they will be approved by the European Commission - subsequent versions of the EUPL (the "Licence");
* You may not use this work except in compliance with theLicence.
* You may obtain a copy of the Licence at:
* * https://joinup.ec.europa.eu/software/page/eupl *
* Unless required by applicable law or agreed to in writing, software distributed under the Licence is distributed on an "AS IS" basis,
* WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
* See the Licence for the specific language governing permissions and limitations under the Licence.*/

import 'package:energielabel_app/ui/pdf/utils/pdf_html_renderer.dart';
import 'package:flutter_html/html_parser.dart';
import 'package:html/dom.dart' as dom;
import 'package:pdf/widgets.dart';

typedef HtmlRenderer = Widget Function(dom.Node);

class PdfHtmlUtils {
  static Map<String, PdfHtmlRenderer> htmlRenderers = {
    'ul': ListsRenderer(),
    'ol': ListsRenderer(),
    'li': LiRenderer(),
  };

  static Widget htmlStringToPdfWidget(
    Context context,
    String html,
  ) {
    final dom.Document document = HtmlParser.parseHTML(html);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: _buildPdfWidgetsFromNodeList(document.body!.nodes),
    );
  }

  static List<Widget> _buildPdfWidgetsFromNodeList(dom.NodeList nodeList) {
    final List<Widget> pdfWidgets = [];
    final List<dom.Node> nodes = List.from(nodeList);

    do {
      final textElements = nodes
          .takeWhile((node) =>
              !(node.runtimeType == dom.Element && htmlRenderers.containsKey((node as dom.Element).localName)))
          .toList();

      if (textElements.isNotEmpty) {
        nodes.removeRange(0, nodes.indexOf(textElements.last) + 1);

        pdfWidgets.add(_renderRichText(textElements));
      }

      final otherNodes = nodes
          .takeWhile((node) =>
              node.runtimeType != dom.Text ||
              (node.runtimeType == dom.Element && !htmlRenderers.containsKey((node as dom.Element).localName)))
          .toList();

      if (otherNodes.isNotEmpty) {
        nodes.removeRange(0, nodes.indexOf(otherNodes.last) + 1);

        for (var node in otherNodes) {
          pdfWidgets.add(_renderWidgetsFromNodes(node as dom.Element));
        }
      }
    } while (nodes.isNotEmpty);

    return pdfWidgets;
  }

  static Widget _renderWidgetsFromNodes(dom.Element element) {
    if (htmlRenderers.containsKey(element.localName)) {
      return htmlRenderers[element.localName!]!.render(element, _buildPdfWidgetsFromNodeList, _renderRichText);
    } else {
      return _renderText(element);
    }
  }

  static Widget _renderText(dom.Node node) {
    return Text(
      node.text!.replaceAll('<br />', '\n'),
      textAlign: TextAlign.left,
    );
  }

  static Widget _renderRichText(List<dom.Node> nodeList) {
    final List<InlineSpan> inlineSpans = [];

    for (final childNode in nodeList) {
      if (childNode.runtimeType == dom.Element) {
        final childElement = childNode as dom.Element;

        if (childElement.localName == 'a' && childElement.attributes['href']!.startsWith('http')) {
          inlineSpans.add(TextSpan(
            text: childElement.text.replaceAll('<br />', '\n'),
            style: const TextStyle(decoration: TextDecoration.underline),
            annotation: AnnotationUrl(childElement.attributes['href']!),
          ));
        } else {
          inlineSpans.add(TextSpan(text: childElement.text.replaceAll('<br />', '\n')));
        }
      } else {
        inlineSpans.add(TextSpan(text: childNode.text!.replaceAll('<br />', '\n')));
      }
    }

    return RichText(text: TextSpan(children: inlineSpans));
  }
}
