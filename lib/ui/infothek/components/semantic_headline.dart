import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/translations.dart';

class SemanticHeadline extends StatelessWidget {
  const SemanticHeadline({
    Key? key,
    required this.title,
    this.titleSemantics,
    this.style,
    this.rank = 1,
    this.padding = EdgeInsets.zero,
  })  : assert(rank >= 1),
        super(key: key);

  final String title;
  final String? titleSemantics;
  final TextStyle? style;
  final int rank;
  final EdgeInsets padding;

  @override
  Widget build(BuildContext context) {
    return Semantics(
      label: Translations.of(context)!.semantics_headline_rank(titleSemantics ?? title, rank.toString()),
      excludeSemantics: true,
      child: Padding(
        padding: padding,
        child: Text(
          title,
          style: style ?? Theme.of(context).textTheme.headline1,
        ),
      ),
    );
  }
}
