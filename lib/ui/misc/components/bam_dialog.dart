/* * Copyright 2020 Bundesanstalt für Materialforschung und -prüfung (BAM) *
* Licensed under the EUPL, Version 1.2 or – as soon they will be approved by the European Commission - subsequent versions of the EUPL (the "Licence");
* You may not use this work except in compliance with theLicence.
* You may obtain a copy of the Licence at:
* * https://joinup.ec.europa.eu/software/page/eupl *
* Unless required by applicable law or agreed to in writing, software distributed under the Licence is distributed on an "AS IS" basis,
* WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
* See the Licence for the specific language governing permissions and limitations under the Licence.*/

import 'dart:ui';

import 'package:energielabel_app/ui/misc/theme/bam_colors.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

/// Function to display a Dialog on screen with a blurred background.
/// [scaffoldBodyKey] is a [GlobalKey] required to calculate the background blur height.
/// The Key must be the First Child in a Scaffolds Body
Future<T?> showDialogWithBlur<T>({
  required BuildContext context,
  required WidgetBuilder builder,
}) async {
  return showDialog<T>(
    context: context,
    barrierColor: Colors.transparent,
    useSafeArea: false,
    builder: (context) {
      return Stack(
        children: [
          BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
            child: Container(color: BamColorPalette.bamBlack.withOpacity(0.75)),
          ),
          builder(context),
        ],
      );
    },
  );
}

class BamDialog extends StatelessWidget {
  const BamDialog.message({
    Key? key,
    required this.title,
    required String this.message,
    this.confirmButtonText,
    this.denyButtonText,
    this.onPressConfirm,
    this.onPressDeny,
  })  : child = null,
        isScrollable = null,
        customButtons = null,
        builder = null,
        super(key: key);

  const BamDialog.customMessage({
    Key? key,
    required this.title,
    required String this.message,
    this.customButtons,
  })  : child = null,
        isScrollable = null,
        confirmButtonText = null,
        denyButtonText = null,
        onPressConfirm = null,
        onPressDeny = null,
        builder = null,
        super(key: key);

  const BamDialog.widget({
    Key? key,
    required this.title,
    required Widget this.child,
    this.confirmButtonText,
    this.denyButtonText,
    this.onPressConfirm,
    this.onPressDeny,
  })  : message = null,
        isScrollable = null,
        customButtons = null,
        builder = null,
        super(key: key);

  const BamDialog.customWidget({
    Key? key,
    required this.title,
    required Widget this.child,
    this.customButtons,
  })  : message = null,
        isScrollable = null,
        confirmButtonText = null,
        denyButtonText = null,
        onPressConfirm = null,
        onPressDeny = null,
        builder = null,
        super(key: key);

  const BamDialog.custom({
    Key? key,
    required this.title,
    required this.builder,
    this.isScrollable = false,
  })  : assert(builder != null),
        customButtons = null,
        child = null,
        message = null,
        confirmButtonText = null,
        denyButtonText = null,
        onPressConfirm = null,
        onPressDeny = null,
        super(key: key);

  final String title;
  final String? message;
  final Widget? child;
  final String? confirmButtonText;
  final String? denyButtonText;
  final VoidCallback? onPressConfirm;
  final VoidCallback? onPressDeny;
  final List<Widget>? customButtons;
  final WidgetBuilder? builder;
  final bool? isScrollable;

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: Colors.white.withOpacity(0.9),
      insetPadding: const EdgeInsets.all(32),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(6)),
      child: SizedBox(
        width: MediaQuery.of(context).size.width > 500 ? 500 : double.infinity,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Padding(
              padding: const EdgeInsets.only(top: 32, bottom: 8, left: 16, right: 16),
              child: Text(
                title,
                style: Theme.of(context).textTheme.headline1!.copyWith(color: BamColorPalette.bamBlue3),
              ),
            ),
            if (child != null || message != null)
              Padding(
                padding: const EdgeInsets.only(top: 8, bottom: 32, left: 16, right: 16),
                child: child ??
                    Text(
                      message!,
                      style: Theme.of(context).textTheme.bodyText2,
                      textAlign: TextAlign.center,
                    ),
              ),
            if (builder == null)
              Padding(
                padding: const EdgeInsets.only(bottom: 40, left: 48, right: 48),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    if (customButtons != null)
                      ...customButtons!
                    else ...[
                      if (confirmButtonText != null)
                        TextButton(
                          onPressed: onPressConfirm,
                          style: TextButton.styleFrom(
                            backgroundColor: Theme.of(context).colorScheme.secondaryVariant,
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                            padding: const EdgeInsets.only(top: 18, bottom: 14),
                          ),
                          child: Text(
                            confirmButtonText!.toUpperCase(),
                            style: Theme.of(context).textTheme.button!.copyWith(color: BamColorPalette.bamWhite),
                          ),
                        ),
                      if (denyButtonText != null) SizedBox(height: 20),
                      if (denyButtonText != null)
                        OutlinedButton(
                          onPressed: onPressDeny,
                          style: OutlinedButton.styleFrom(
                            primary: Theme.of(context).colorScheme.surface,
                            side: BorderSide(color: BamColorPalette.bamBlue1Optimized),
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                            padding: const EdgeInsets.only(top: 18, bottom: 14),
                          ),
                          child: Text(
                            denyButtonText!.toUpperCase(),
                            style:
                                Theme.of(context).textTheme.button!.copyWith(color: BamColorPalette.bamBlue1Optimized),
                          ),
                        ),
                    ]
                  ],
                ),
              )
            else
              _buildCustom(context),
          ],
        ),
      ),
    );
  }

  Widget _buildCustom(BuildContext context) {
    if (isScrollable!) {
      return Expanded(
        child: Scrollbar(
          child: SingleChildScrollView(
            child: builder!(context),
          ),
        ),
      );
    } else {
      return builder!(context);
    }
  }
}
