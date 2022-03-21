import 'package:energielabel_app/ui/infothek/components/semantic_headline.dart';
import 'package:energielabel_app/ui/misc/theme/bam_colors.dart';
import 'package:flutter/material.dart';

class TitledParagraph extends StatelessWidget {
  const TitledParagraph({
    Key? key,
    this.title,
    this.titleSemantics,
    this.text = const [],
    this.children = const [],
    this.titleRank = 1,
    this.titleStyle,
    this.titleColor = BamColorPalette.bamBlue3,
  }) : super(key: key);

  final String? title;
  final String? titleSemantics;
  final List<InlineSpan> text;
  final List<Widget> children;
  final int titleRank;
  final TextStyle? titleStyle;
  final Color titleColor;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (title != null)
          SemanticHeadline(
            title: title ?? '',
            titleSemantics: titleSemantics,
            rank: titleRank,
            padding: const EdgeInsets.only(left: 16, right: 16, top: 16),
            style: (titleStyle ?? Theme.of(context).textTheme.headline1)!.copyWith(color: titleColor),
          ),
        if (text.isNotEmpty || children.isNotEmpty)
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Row(
              children: [
                Expanded(
                  child: RichText(
                    textScaleFactor: MediaQuery.of(context).textScaleFactor,
                    strutStyle: StrutStyle.fromTextStyle(
                      Theme.of(context).textTheme.bodyText1!,
                      fontWeight: MediaQuery.boldTextOverride(context) ? FontWeight.bold : null,
                    ),
                    text: TextSpan(
                      style: Theme.of(context).textTheme.bodyText2,
                      children: text,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ...children,
      ],
    );
  }
}
