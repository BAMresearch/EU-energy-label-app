import 'dart:io';

import 'package:energielabel_app/ui/misc/theme/bam_colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/translations.dart';
import 'package:responsive_layout_builder/responsive_layout_builder.dart';

import 'external_link.dart';

class InfoDetailItem extends StatelessWidget {
  const InfoDetailItem({
    Key? key,
    required this.title,
    this.subTitle,
    required this.externalTarget,
    this.icon,
    this.onTap,
    this.titleMaxLines = 1,
    this.subTitleMaxLines = 1,
    this.semanticLabel,
    this.useTitleOnlyForSemantics = false,
    this.padding = const EdgeInsets.symmetric(vertical: 8),
    this.contentPadding = const EdgeInsets.symmetric(vertical: 16, horizontal: 16),
    this.iconPadding = const EdgeInsets.only(right: 16),
  })  : link = null,
        super(key: key);

  const InfoDetailItem.fromLink({
    Key? key,
    required this.title,
    this.subTitle,
    required this.link,
    this.titleMaxLines = 2,
    this.subTitleMaxLines = 1,
    this.semanticLabel,
    this.useTitleOnlyForSemantics = false,
    this.padding = const EdgeInsets.symmetric(vertical: 8),
    this.contentPadding = const EdgeInsets.symmetric(vertical: 16, horizontal: 16),
    this.icon,
    this.iconPadding = const EdgeInsets.only(right: 24),
  })  : onTap = null,
        externalTarget = null,
        super(key: key);

  final String title;
  final String? subTitle;
  final VoidCallback? onTap;
  final int titleMaxLines;
  final int subTitleMaxLines;
  final EdgeInsets padding;
  final EdgeInsets contentPadding;
  final String? semanticLabel;
  final ExternalTarget? externalTarget;
  final ExternalLink? link;
  final Widget? icon;
  final EdgeInsets iconPadding;
  final bool useTitleOnlyForSemantics;

  String _formatSubTitle(ExternalLink externalLink) {
    if (externalLink.externalTarget == ExternalTarget.phone) {
      final phoneNumber = subTitle?.replaceAll(RegExp(r'[\[\\\^\$\.\|\?\*\/\(\)\{\}\-\ ]'), '') ?? '';
      if (Platform.isAndroid) {
        return phoneNumber.split('').join(' ');
      }
      return phoneNumber;
    }
    return subTitle ?? '';
  }

  String _formatSemanticLabel(BuildContext context, ExternalLink externalLink) {
    final label = semanticLabel ?? '$title \n${_formatSubTitle(externalLink)}';
    if (externalLink.externalTarget == ExternalTarget.none) {
      return label;
    } else if (externalLink.externalTarget == ExternalTarget.phone &&
        getContextualScreenSize(context: context).size != LayoutSize.mobile) {
      return '${semanticLabel ?? title} \n${_formatSubTitle(externalLink)}';
    }

    return Translations.of(context)!.semantics_open_link_template(
      label,
      externalLink.getSemanticExternalTarget(context),
    );
  }

  @override
  Widget build(BuildContext context) {
    final externalLink = link ?? ExternalLink.onlyTargetType(externalTarget: externalTarget);
    return Padding(
      padding: padding,
      child: Semantics(
        label: _formatSemanticLabel(context, externalLink),
        container: true,
        excludeSemantics: true,
        child: TextButton(
          style: ButtonStyle(
            elevation: MaterialStateProperty.all(0),
            overlayColor: MaterialStateProperty.all(BamColorPalette.bamBlack10),
            backgroundColor: MaterialStateProperty.all(Theme.of(context).colorScheme.surface),
            shape: MaterialStateProperty.all(RoundedRectangleBorder(borderRadius: BorderRadius.circular(8))),
          ),
          onPressed: onTap ?? externalLink.getOnActionCaller(context),
          child: Padding(
            padding: contentPadding,
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Padding(
                  padding: iconPadding,
                  child: icon,
                ),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      if (!useTitleOnlyForSemantics)
                        Text(
                          title,
                          style:
                              Theme.of(context).textTheme.subtitle2!.copyWith(color: BamColorPalette.bamBlue1Optimized),
                          maxLines: titleMaxLines,
                          overflow: TextOverflow.ellipsis,
                        ),
                      if (subTitle != null)
                        Text(
                          subTitle!,
                          style: Theme.of(context).textTheme.subtitle1,
                          maxLines: subTitleMaxLines,
                          overflow: TextOverflow.ellipsis,
                        ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
