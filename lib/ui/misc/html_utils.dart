/* * Copyright 2020 Bundesanstalt für Materialforschung und -prüfung (BAM) *
* Licensed under the EUPL, Version 1.2 or – as soon they will be approved by the European Commission - subsequent versions of the EUPL (the "Licence");
* You may not use this work except in compliance with theLicence.
* You may obtain a copy of the Licence at:
* * https://joinup.ec.europa.eu/software/page/eupl *
* Unless required by applicable law or agreed to in writing, software distributed under the Licence is distributed on an "AS IS" basis,
* WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
* See the Licence for the specific language governing permissions and limitations under the Licence.*/

import 'dart:collection';
import 'dart:convert';

import 'package:energielabel_app/app_uri_schemes.dart';
import 'package:energielabel_app/data/asset_paths.dart';
import 'package:energielabel_app/ui/misc/tab_routes.dart';
import 'package:energielabel_app/ui/misc/tab_scaffold.dart';
import 'package:energielabel_app/ui/misc/theme/bam_colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:flutter_html/html_parser.dart';
import 'package:flutter_html/style.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:pedantic/pedantic.dart';
import 'package:url_launcher/url_launcher.dart';

class HtmlUtils {
  static Widget stringToHtml(
    BuildContext context,
    String? html, {
    Key? key,
    Color? bulletColor,
    Color? textColor,
    Map<String, Style>? customStyle,
    EdgeInsets padding = const EdgeInsets.all(8.0),
    Future<bool> Function(String? url)? onLinkTap,
  }) {
    final internalOnTap = (String? link) async {
      if (onLinkTap != null && await onLinkTap(link)) {
        return;
      }

      final Uri uri = Uri.parse(link!);
      //  example URL
      //  energylabelapp:pushPage?tab=knowHow&page=glossary

      if (uri.isScheme(AppUriSchemes.appScheme) && uri.path == AppUriSchemes.pushPagePath && uri.hasQuery) {
        final TabRoute? tabRoute = TabRoutes.getRoute(uri.queryParameters[AppUriSchemes.queryParameterTab],
            uri.queryParameters[AppUriSchemes.queryParameterPage]);

        final Type? tabSpecificationType =
            TabRoutes.getSpecification(uri.queryParameters[AppUriSchemes.queryParameterTab]);
        final bool isTabSelected =
            TabScaffold.of(context)!.currentTabSpecification().runtimeType == tabSpecificationType;

        if (isTabSelected) {
          unawaited(
            Navigator.of(context)
                .pushNamed(tabRoute!.route!, arguments: uri.queryParameters[AppUriSchemes.queryParameterArguments]),
          );
        } else {
          TabScaffold.of(context)!.navigateIntoTab(tabSpecificationType, tabRoute!.route,
              routeArguments: uri.queryParameters[AppUriSchemes.queryParameterArguments]);
        }
      } else if (await canLaunch(link)) {
        unawaited(launch(link));
      }
    };

    final formattedHtml = html?.replaceAll('<p></p>', '');
    return Html(
      key: key,
      data: formattedHtml,
      onLinkTap: (String? url, context, attributes, elements) {
        internalOnTap(url);
      },
      style: {
        'body': Style(margin: EdgeInsets.zero, color: textColor),
        '*': Style.fromTextStyle(Theme.of(context).textTheme.bodyText2!.copyWith(color: textColor)),
        'li': Style(
          margin: EdgeInsets.zero,
          padding: EdgeInsets.only(bottom: 0),
          color: textColor,
        ),
        'p': Style(
          padding: EdgeInsets.only(bottom: 12),
          margin: EdgeInsets.zero,
          color: textColor,
        ),
        'strong': Style(
          fontWeight: FontWeight.bold,
          color: textColor,
        ),
        'h1': Style.fromTextStyle(
            Theme.of(context).textTheme.headline1!.copyWith(color: textColor ?? BamColorPalette.bamBlue3)),
        'h2': Style.fromTextStyle(
            Theme.of(context).textTheme.headline2!.copyWith(color: textColor ?? BamColorPalette.bamBlue3)),
        'h3': Style.fromTextStyle(
            Theme.of(context).textTheme.headline3!.copyWith(color: textColor ?? BamColorPalette.bamBlue3)),
        'h4': Style.fromTextStyle(Theme.of(context).textTheme.headline4!.copyWith(color: textColor)),
        'h5': Style.fromTextStyle(Theme.of(context).textTheme.headline5!.copyWith(color: textColor)),
        'h6': Style.fromTextStyle(Theme.of(context).textTheme.headline6!.copyWith(color: textColor)),
        if (customStyle != null) ...customStyle
      },
      customRender: {
        'img': (context, child) => _customRenderImg(context, child),
        'a': (context, child) => _customRenderA(context, child, internalOnTap),
        'li': (context, child) => _customRenderLi(context, child, padding, bulletColor),
      },
    );
  }

  static Widget _customRenderImg(RenderContext context, Widget child) {
    final LinkedHashMap<Object, String> attributes = context.tree.element!.attributes;

    //static Widget _customRenderImg(
    //  RenderContext context, Widget child, Map<String, String> attributes, dom.Element currentElement) {
    final String widthString = attributes['width'] ?? '';
    final String heightString = attributes['height'] ?? '';

    final double? width = double.tryParse(widthString.split('%').first);
    final double? height = double.tryParse(heightString.split('%').first);

    if (widthString.endsWith('%') || heightString.endsWith('%')) {
      return Align(
        alignment: attributes['align'] == 'center' ? Alignment.center : Alignment.topLeft,
        child: FractionallySizedBox(
          widthFactor: width != null ? width / 100 : width,
          heightFactor: height != null ? height / 100 : height,
          child: attributes['src']!.startsWith('https://')
              ? Image.network(
                  attributes['src']!,
                  fit: BoxFit.cover,
                )
              : Image.memory(base64Decode(attributes['src']!.split(', ').last)),
        ),
      );
    } else {
      return Image.network(attributes['src']!);
    }
  }

  static Widget _customRenderA(RenderContext context, Widget child, void Function(String link) onLinkTap) {
    final LinkedHashMap<Object, String> attributes = context.tree.element!.attributes;
    Widget widget;
    if (attributes['href']!.startsWith('http')) {
      widget = Wrap(
        crossAxisAlignment: WrapCrossAlignment.center,
        children: [
          SvgPicture.asset(
            AssetPaths.externalLinkIcon,
            height: 13,
          ),
          SizedBox(width: 4),
          child,
        ],
      );
    } else {
      widget = child;
    }

    return GestureDetector(
      onTap: () => onLinkTap(attributes['href'] ?? ''),
      child: widget,
    );
  }

  static Widget _customRenderLi(RenderContext context, Widget child, EdgeInsets padding, Color? bulletColor) {
    final currentElement = context.tree.element!;

    late String elementPrefix;
    double? fontSize;
    if (currentElement.parent!.localName == 'ol') {
      // Get index of current li element in ol parent
      final index = currentElement.parent!.nodes.indexWhere((liElement) => liElement == currentElement) + 1;
      elementPrefix = '$index.';

      if (currentElement.parent!.attributes.containsKey('type') && currentElement.parent!.attributes['type'] == 'a') {
        elementPrefix = String.fromCharCode(('a'.codeUnitAt(0)) + index - 1) + '.';
      }
    } else if (currentElement.parent!.localName == 'ul') {
      elementPrefix = currentElement.parent!.parent!.localName != 'li' ? '●' : '○';
      fontSize = 13.0;
    }
    return Padding(
      padding: padding,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        textBaseline: TextBaseline.ideographic,
        children: [
          Text(elementPrefix, style: TextStyle(color: bulletColor, fontSize: fontSize)),
          SizedBox(width: 8),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [child],
            ),
          )
        ],
      ),
    );
  }
}
