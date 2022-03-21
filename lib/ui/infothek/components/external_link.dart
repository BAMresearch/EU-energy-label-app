import 'dart:async';
import 'package:flutter/widgets.dart';

import 'package:url_launcher/url_launcher.dart';
import 'package:flutter_gen/gen_l10n/translations.dart';

enum ExternalTarget { web, email, phone, none }

class ExternalLink {
  ExternalLink({
    required this.targetAddress,
    this.externalTarget = ExternalTarget.web,
  });

  ExternalLink.onlyTargetType({
    ExternalTarget? externalTarget,
  })  : targetAddress = null,
        externalTarget = externalTarget ?? ExternalTarget.web;

  final String? targetAddress;
  final ExternalTarget externalTarget;

  String getSemanticExternalTarget(BuildContext context) {
    try {
      switch (externalTarget) {
        case ExternalTarget.web:
          return Translations.of(context)!.ext_dialog_open_link_button;
        case ExternalTarget.email:
          return Translations.of(context)!.semantic_open_link_email;
        case ExternalTarget.phone:
          return Translations.of(context)!.semantic_open_link_phone;
        case ExternalTarget.none:
          return '';
        default:
          return Translations.of(context)!.ext_dialog_open_link_button;
      }
    } catch (e) {
      throw UnsupportedError('This Method can only be used in BayernCommon Module! ${e.toString()}');
    }
  }

  Function()? getOnActionCaller(BuildContext context) {
    if (targetAddress != null && externalTarget != ExternalTarget.none) {
      return () => onAction(context);
    }
    return null;
  }

  void onAction(BuildContext context) {
    if (targetAddress == null) {
      return;
    }

    switch (externalTarget) {
      case ExternalTarget.web:
        onWebLinkTapped(targetAddress!, context);
        break;
      case ExternalTarget.email:
        onEmailAction(targetAddress!);
        break;
      case ExternalTarget.phone:
        onPhoneNumberAction(targetAddress!);
        break;
      case ExternalTarget.none:
        break;
      default:
    }
  }

  static void onWebLinkTapped(String url, BuildContext context) async {
    final webUri = url.startsWith('http://') || url.startsWith('https://') ? url : 'https://$url';

    if (await canLaunch(webUri)) {
      unawaited(launch(webUri));
    }
  }

  static void onEmailAction(String email) async {
    final mailUri = 'mailto:$email';

    if (await canLaunch(mailUri)) {
      unawaited(launch(mailUri));
    }
  }

  static String removePhoneNumberArtifacts(String phoneNumber) {
    return phoneNumber.replaceAll(RegExp(r'[\[\\\^\$\.\|\?\*\/\(\)\{\}\-\ ]'), '');
  }

  static void onPhoneNumberAction(String phoneNumber) async {
    final formattedNumber = removePhoneNumberArtifacts(phoneNumber);
    final telUri = 'tel:$formattedNumber';

    if (await canLaunch(telUri)) {
      unawaited(launch(telUri));
    }
  }
}
