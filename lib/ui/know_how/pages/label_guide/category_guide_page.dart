/* * Copyright 2020 Bundesanstalt für Materialforschung und -prüfung (BAM) *
* Licensed under the EUPL, Version 1.2 or – as soon they will be approved by the European Commission - subsequent versions of the EUPL (the "Licence");
* You may not use this work except in compliance with theLicence.
* You may obtain a copy of the Licence at:
* * https://joinup.ec.europa.eu/software/page/eupl *
* Unless required by applicable law or agreed to in writing, software distributed under the Licence is distributed on an "AS IS" basis,
* WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
* See the Licence for the specific language governing permissions and limitations under the Licence.*/

import 'dart:math' as math;

import 'package:async/async.dart';
import 'package:energielabel_app/data/asset_paths.dart';
import 'package:energielabel_app/model/know_how/label_guide/label_category.dart';
import 'package:energielabel_app/model/know_how/label_guide/label_category_guide_data.dart';
import 'package:energielabel_app/ui/know_how/components/category_header.dart';
import 'package:energielabel_app/ui/know_how/components/label_guide/general_information_widget.dart';
import 'package:energielabel_app/ui/know_how/pages/label_guide/category_guide_view_model.dart';
import 'package:energielabel_app/ui/misc/html_utils.dart';
import 'package:energielabel_app/ui/misc/page_scaffold.dart';
import 'package:energielabel_app/ui/misc/pages/base_page.dart';
import 'package:energielabel_app/ui/misc/theme/bam_colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_gen/gen_l10n/translations.dart';
import 'package:provider/provider.dart';

class CategoryGuidePageArguments {
  const CategoryGuidePageArguments({@required this.labelCategory}) : assert(labelCategory != null);

  final LabelCategory labelCategory;
}

class CategoryGuidePage extends StatelessPage<CategoryGuideViewModel> {
  CategoryGuidePage({@required CategoryGuidePageArguments initialArguments})
      : assert(initialArguments != null),
        _labelCategory = initialArguments.labelCategory;

  final LabelCategory _labelCategory;

  LabelCategoryGuideData get _labelGuide => _labelCategory.guideData;

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<CategoryGuideViewModel>(
      create: (context) => createViewModel(context)..onViewStarted(),
      child: PageScaffold(
        title: Translations.of(context).guide_page_title,
        body: _buildBody(context),
      ),
    );
  }

  final verticalScrollController = ScrollController();

  Widget _buildBody(BuildContext context) {
    return Scrollbar(
      child: ListView(
        controller: verticalScrollController,
        physics: ClampingScrollPhysics(),
        padding: EdgeInsets.zero,
        children: [
          _buildGuideHeader(context),
          const SizedBox(height: 32),
          Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              _buildGuideIntro(context),
              const SizedBox(height: 27),
              _buildInfoZone(context, verticalScrollController),
              const SizedBox(height: 42),
              _PaddedGuideWidget(child: Text(_labelGuide.outroText)),
              const SizedBox(height: 27),
              _PaddedGuideWidget(
                child: GeneralInformationWidget(
                  informationTitle: _labelGuide.informationTitle,
                  informationText: _labelGuide.informationText,
                ),
              ),
              const SizedBox(height: 123),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildGuideHeader(BuildContext context) {
    return CategoryHeader(
      title: _labelGuide.title,
      backgroundColorHex: _labelCategory.backgroundColorHex,
      titleColorHex: _labelCategory.textColorHex,
      image: AssetPaths.labelGuideCategoryImage(_labelCategory.graphicPath),
    );
  }

  Widget _buildGuideIntro(BuildContext context) {
    return _PaddedGuideWidget(child: Text(_labelGuide.introText));
  }

  Widget _buildInfoZone(BuildContext context, ScrollController verticalScrollController) {
    return Padding(
      padding: const EdgeInsets.only(left: 5),
      child: FridgeInfoZone(
        guideData: _labelGuide,
        enclosingScrollController: verticalScrollController,
      ),
    );
  }

  @override
  CategoryGuideViewModel createViewModel(BuildContext context) {
    return CategoryGuideViewModel();
  }
}

class _PaddedGuideWidget extends StatelessWidget {
  const _PaddedGuideWidget({
    Key key,
    @required this.child,
    this.horizontalPaddingValue = 20,
  })  : assert(child != null),
        super(key: key);

  final Widget child;
  final double horizontalPaddingValue;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: horizontalPaddingValue),
      child: child,
    );
  }
}

class FridgeInfoZone extends StatefulWidget {
  const FridgeInfoZone({
    Key key,
    @required this.guideData,
    this.enclosingScrollController,
  })  : assert(guideData != null),
        super(key: key);

  final LabelCategoryGuideData guideData;
  final ScrollController enclosingScrollController;

  @override
  _FridgeInfoZoneState createState() => _FridgeInfoZoneState();
}

double _getScaledToDisplayWithReference(double size) {
  final shortestSide = _getWindowSize.shortestSide;
  if (shortestSide < 600) {
    // Smartphone
    return size;
  } else if (shortestSide >= 600 && shortestSide < 720) {
    // 7 inch tablet
    return size * 1.7;
  } else {
    // 10+ inch tablet
    return size * 2.0;
  }
}

Size get _getWindowSize => MediaQueryData.fromWindow(WidgetsBinding.instance.window).size;

bool get _runsOnTablet => _getWindowSize.shortestSide >= 600;

final double _bubbleHeight = _getScaledToDisplayWithReference(62);

double _getBottomPosition(BoxConstraints constraints, double bubbleTop) =>
    constraints.maxHeight - bubbleTop - _bubbleHeight;

double _getRightPosition(BoxConstraints constraints, double bubbleLeft) =>
    constraints.maxWidth - bubbleLeft - _bubbleHeight;

double _getLeftPosition(BoxConstraints constraints, double bubbleRight) =>
    constraints.maxWidth - bubbleRight - _bubbleHeight;

double get _tooltipWidth {
  final widthConstraint = math.min(
    _getScaledToDisplayWithReference(300.0),
    (_getWindowSize.width - tooltipMarginToLeftSideOfScreen) * 0.9,
  );
  return widthConstraint;
}

final double tooltipMarginToLeftSideOfScreen = _getScaledToDisplayWithReference(33);

class _FridgeInfoZoneState extends State<FridgeInfoZone> with SingleTickerProviderStateMixin {
  final ValueNotifier<bool> _showLeftFridgeSide = ValueNotifier(true);
  ScrollController _fridgeScrollController;
  AnimationController _switchFridgeSideAnimationController;

  @override
  void initState() {
    super.initState();

    _fridgeScrollController = ScrollController();
    _switchFridgeSideAnimationController = AnimationController(
      duration: const Duration(milliseconds: 400),
      vsync: this,
    );
  }

  @override
  Widget build(BuildContext context) {
    return ConstrainedBox(
      constraints: BoxConstraints(maxHeight: _getScaledToDisplayWithReference(409)),
      child: LayoutBuilder(
        builder: (context, constraints) {
          return Stack(
            children: [
              SingleChildScrollView(
                physics: NeverScrollableScrollPhysics(),
                controller: _fridgeScrollController,
                scrollDirection: Axis.horizontal,
                child: _FridgeBackgroundSwitcher(
                  switchSideNotifier: _showLeftFridgeSide,
                  duration: _switchFridgeSideAnimationController.duration,
                ),
              ),
              FridgeInfoButtons(
                guideData: widget.guideData,
                showLeftFridgeSide: _showLeftFridgeSide,
                constraints: constraints,
                duration: _switchFridgeSideAnimationController.duration,
                enclosingScrollController: widget.enclosingScrollController,
              ),
              _FridgeSideSwitchButton(
                constraints: constraints,
                switchSideAnimation: _switchFridgeSideAnimationController,
                onPressed: () {
                  _showLeftFridgeSide.value = !_showLeftFridgeSide.value;
                  _showLeftFridgeSide.value
                      ? _switchFridgeSideAnimationController.reverse()
                      : _switchFridgeSideAnimationController.forward();
                  _fridgeScrollController.animateTo(
                    _showLeftFridgeSide.value ? 0 : _fridgeScrollController.position.maxScrollExtent,
                    duration: _switchFridgeSideAnimationController.duration,
                    curve: Curves.easeOut,
                  );
                },
              ),
            ],
          );
        },
      ),
    );
  }

  @override
  void dispose() {
    _fridgeScrollController.dispose();
    _switchFridgeSideAnimationController.dispose();

    super.dispose();
  }
}

class _FridgeBackgroundSwitcher extends StatelessWidget {
  const _FridgeBackgroundSwitcher({
    Key key,
    @required this.switchSideNotifier,
    @required this.duration,
  })  : assert(switchSideNotifier != null),
        assert(duration != null),
        super(key: key);

  final ValueNotifier<bool> switchSideNotifier;
  final Duration duration;

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<bool>(
      valueListenable: switchSideNotifier,
      builder: (context, showLeft, child) {
        return AnimatedCrossFade(
          crossFadeState: showLeft ? CrossFadeState.showFirst : CrossFadeState.showSecond,
          duration: duration,
          firstChild: Image.asset(AssetPaths.knowHowFridgeInfoZonesImage),
          secondChild: Image.asset(AssetPaths.knowHowFridgeInfoZonesRightImage),
        );
      },
    );
  }
}

class _FridgeSideSwitchButton extends StatelessWidget {
  const _FridgeSideSwitchButton({
    Key key,
    @required this.onPressed,
    @required this.switchSideAnimation,
    @required this.constraints,
  })  : assert(switchSideAnimation != null),
        assert(onPressed != null),
        assert(constraints != null),
        super(key: key);

  final BoxConstraints constraints;
  final VoidCallback onPressed;
  final Animation switchSideAnimation;

  static final double _switchBubbleTop = _getScaledToDisplayWithReference(152.0);
  static final double _switchBubbleLeft = _getScaledToDisplayWithReference(290.0);
  static final double _switchBubbleRightIfTablet = 48;

  @override
  Widget build(BuildContext context) {
    final rotationTween = Tween(begin: 0.0, end: 0.5);
    final roundedInfoZoneButton = _RoundedInfoZoneButton(
      height: _bubbleHeight,
      onPressed: onPressed,
      child: Image.asset(AssetPaths.knowHowFridgeInfoZonesSwitchSideBubbleImage),
    );

    final double defaultPadding = _getScaledToDisplayWithReference(20.0);
    final windowWidth = MediaQuery.of(context).size.width;
    final switchButtonWillFitOnScreen = windowWidth >= _switchBubbleLeft + _bubbleHeight;
    final leftPosition = switchButtonWillFitOnScreen ? _switchBubbleLeft : windowWidth - _bubbleHeight - defaultPadding;
    final topPosition = switchButtonWillFitOnScreen && _runsOnTablet == false
        ? _switchBubbleTop
        : _switchBubbleTop - defaultPadding * _getScaledToDisplayWithReference(1.5);
    final bottomPosition = _getBottomPosition(constraints, topPosition);

    final positionedTween = RelativeRectTween(
      begin: RelativeRect.fromLTRB(
        _runsOnTablet ? windowWidth - _bubbleHeight - defaultPadding - _switchBubbleRightIfTablet : leftPosition,
        topPosition,
        _runsOnTablet ? _switchBubbleRightIfTablet : _getRightPosition(constraints, leftPosition),
        bottomPosition,
      ),
      end: RelativeRect.fromLTRB(
        defaultPadding,
        topPosition,
        _getRightPosition(constraints, defaultPadding),
        bottomPosition,
      ),
    );

    return AnimatedBuilder(
      animation: switchSideAnimation,
      builder: (context, child) {
        return PositionedTransition(
          rect: positionedTween.animate(switchSideAnimation),
          child: RotationTransition(
            turns: rotationTween.animate(switchSideAnimation),
            child: child,
          ),
        );
      },
      child: roundedInfoZoneButton,
    );
  }
}

class FridgeInfoButtons extends StatelessWidget {
  const FridgeInfoButtons({
    Key key,
    @required this.showLeftFridgeSide,
    @required this.constraints,
    @required this.duration,
    @required this.guideData,
    this.enclosingScrollController,
  })  : assert(showLeftFridgeSide != null),
        assert(constraints != null),
        assert(duration != null),
        assert(guideData != null),
        super(key: key);

  final ValueNotifier<bool> showLeftFridgeSide;
  final BoxConstraints constraints;
  final Duration duration;
  final LabelCategoryGuideData guideData;
  final ScrollController enclosingScrollController;

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder(
      valueListenable: showLeftFridgeSide,
      builder: (context, showLeft, child) {
        final stack = ConstrainedBox(
          constraints: constraints,
          child: Stack(
            children: [
              if (showLeft)
                ..._buildLeftSideInfoBubbles(
                  constraints,
                  guideData.fridgeLeftSideInfoZones,
                  enclosingScrollController: enclosingScrollController,
                )
              else
                ..._buildRightSideInfoBubbles(
                  constraints,
                  guideData.fridgeRightSideInfoZones,
                  enclosingScrollController: enclosingScrollController,
                ),
            ],
          ),
        );

        return FutureBuilder(
          future: Future.delayed(const Duration(milliseconds: 500)),
          builder: (context, snapshot) {
            if (snapshot.connectionState != ConnectionState.done) {
              return Opacity(opacity: 0);
            }

            return TweenAnimationBuilder(
              tween: Tween(begin: 0.0, end: 1.0),
              duration: duration,
              builder: (context, opacity, child) {
                return Opacity(
                  opacity: opacity,
                  child: stack,
                );
              },
            );
          },
        );
      },
    );
  }

  List<Widget> _buildLeftSideInfoBubbles(
    BoxConstraints constraints,
    List<FridgeInfoZoneData> leftZones, {
    ScrollController enclosingScrollController,
  }) {
    assert((leftZones ?? []).length >= 4);

    const double _firstBubbleTop = 0.0;
    final double _firstBubbleLeft = _getScaledToDisplayWithReference(191.8);

    final double _secondBubbleTop = _getScaledToDisplayWithReference(120.0);
    final double _secondBubbleLeft = _getScaledToDisplayWithReference(75.0);

    final double _thirdBubbleTop = _getScaledToDisplayWithReference(210.0);
    final double _thirdBubbleLeft = _getScaledToDisplayWithReference(220.0);

    final double _fourthBubbleTop = _getScaledToDisplayWithReference(340.0);
    final double _fourthBubbleLeft = _getScaledToDisplayWithReference(110.0);

    return [
      Positioned(
        top: _firstBubbleTop,
        bottom: _getBottomPosition(constraints, _firstBubbleTop),
        left: _firstBubbleLeft,
        right: _getRightPosition(constraints, _firstBubbleLeft),
        child: _InfoZoneBubble(infoZone: leftZones.elementAt(0), enclosingScrollController: enclosingScrollController),
      ),
      Positioned(
        top: _secondBubbleTop,
        bottom: _getBottomPosition(constraints, _secondBubbleTop),
        left: _secondBubbleLeft,
        right: _getRightPosition(constraints, _secondBubbleLeft),
        child: _InfoZoneBubble(infoZone: leftZones.elementAt(1), enclosingScrollController: enclosingScrollController),
      ),
      Positioned(
        top: _thirdBubbleTop,
        bottom: _getBottomPosition(constraints, _thirdBubbleTop),
        left: _thirdBubbleLeft,
        right: _getRightPosition(constraints, _thirdBubbleLeft),
        child: _InfoZoneBubble(infoZone: leftZones.elementAt(2), enclosingScrollController: enclosingScrollController),
      ),
      Positioned(
        top: _fourthBubbleTop,
        bottom: _getBottomPosition(constraints, _fourthBubbleTop),
        left: _fourthBubbleLeft,
        right: _getRightPosition(constraints, _fourthBubbleLeft),
        child: _InfoZoneBubble(infoZone: leftZones.elementAt(3), enclosingScrollController: enclosingScrollController),
      ),
    ];
  }

  List<Widget> _buildRightSideInfoBubbles(
    BoxConstraints constraints,
    List<FridgeInfoZoneData> rightZones, {
    ScrollController enclosingScrollController,
  }) {
    assert((rightZones ?? []).length >= 3);

    const _firstBubbleTop = 0.0;
    final _firstBubbleRight = _getScaledToDisplayWithReference(166.83);

    final _secondBubbleTop = _getScaledToDisplayWithReference(135.0);
    final _secondBubbleRight = _getScaledToDisplayWithReference(58.83);

    final _thirdBubbleTop = _getScaledToDisplayWithReference(342.0);
    final _thirdBubbleRight = _getScaledToDisplayWithReference(148.83);

    return [
      Positioned(
        top: _firstBubbleTop,
        bottom: _getBottomPosition(constraints, _firstBubbleTop),
        left: _getLeftPosition(constraints, _firstBubbleRight),
        right: _firstBubbleRight,
        child: _InfoZoneBubble(infoZone: rightZones.elementAt(0), enclosingScrollController: enclosingScrollController),
      ),
      Positioned(
        top: _secondBubbleTop,
        bottom: _getBottomPosition(constraints, _secondBubbleTop),
        left: _getLeftPosition(constraints, _secondBubbleRight),
        right: _secondBubbleRight,
        child: _InfoZoneBubble(infoZone: rightZones.elementAt(1), enclosingScrollController: enclosingScrollController),
      ),
      Positioned(
        top: _thirdBubbleTop,
        bottom: _getBottomPosition(constraints, _thirdBubbleTop),
        left: _getLeftPosition(constraints, _thirdBubbleRight),
        right: _thirdBubbleRight,
        child: _InfoZoneBubble(infoZone: rightZones.elementAt(2), enclosingScrollController: enclosingScrollController),
      ),
    ];
  }
}

class _InfoZoneBubble extends StatefulWidget {
  _InfoZoneBubble({
    @required this.infoZone,
    this.enclosingScrollController,
  })  : assert(infoZone != null),
        assert(infoZone.description != null),
        assert(infoZone.tooltipHtml != null),
        super(key: GlobalKey());

  final FridgeInfoZoneData infoZone;
  final ScrollController enclosingScrollController;

  @override
  _InfoZoneBubbleState createState() => _InfoZoneBubbleState();
}

class _InfoZoneBubbleState extends State<_InfoZoneBubble> {
  OverlayEntry _enclosingOverlayEntry;
  _Tooltip _tooltip;

  _Tooltip get tooltip => _tooltip;

  bool _tooltipShouldBeRemoved = false;
  RestartableTimer _afterEnclosingScrollEndedTimer;

  bool _createGhost = true;
  OverlayEntry _ghostInOverlay;
  bool _ghostShouldBeRemoved = false;
  final _ghostKey = GlobalKey();

  double get ghostHeight {
    final RenderBox renderBox = _ghostKey.currentContext?.findRenderObject();
    final ghostSize = renderBox?.size;
    return ghostSize?.height ?? 0;
  }

  @override
  void initState() {
    super.initState();

    if (_createGhost) {
      _createGhost = false;
      _ghostInOverlay = OverlayEntry(
        builder: (context) {
          final RenderBox zoneButtonRenderBox = (widget.key as GlobalKey).currentContext?.findRenderObject();
          final Offset zoneButtonCoordinates = zoneButtonRenderBox?.localToGlobal(Offset.zero);

          final triangleOffset = _Tooltip.tooltipTriangleOffset(zoneButtonCoordinates?.dx);
          final moveTooltipToTheRight = _Tooltip.hasToMoveTooltipToTheRight(triangleOffset);
          final moveToRightSideDistance = _Tooltip.moveToTheRightDistance(triangleOffset);

          return Offstage(
            child: Center(
              child: CustomPaint(
                painter: _TooltipPainter(
                  triggeringBubbleLeftPosition: 0,
                  width: _tooltipWidth,
                  paddingLeft: _Tooltip.tooltipPainterPaddingLeft(moveTooltipToTheRight, moveToRightSideDistance),
                  willFitOnTop: true,
                  triangleHeight: 0,
                ),
                child: Builder(
                  builder: (context) {
                    return SizedBox(
                      width: _Tooltip.tooltipContainerWidth(moveTooltipToTheRight, moveToRightSideDistance),
                      child: Padding(
                        key: _ghostKey,
                        padding: EdgeInsets.fromLTRB(
                          _Tooltip.tooltipContentLeftPadding(moveTooltipToTheRight, moveToRightSideDistance),
                          _Tooltip.tooltipContentTopPadding,
                          _Tooltip.tooltipContentRightPadding,
                          _Tooltip.tooltipContentBottomPadding,
                        ),
                        child: HtmlUtils.stringToHtml(
                          context,
                          widget.infoZone.tooltipHtml,
                          textColor: BamColorPalette.bamWhite,
                        ),
                      ),
                    );
                  },
                ),
              ),
            ),
          );
        },
      );

      SchedulerBinding.instance.addPostFrameCallback((_) {
        Overlay.of(context).insert(_ghostInOverlay);
        SchedulerBinding.instance.addPostFrameCallback((_) => _resetTooltip());
      });
    }

    if (enclosingScrollController != null) {
      enclosingScrollController.addListener(_onEnclosingScrollControllerScrolled);
      _afterEnclosingScrollEndedTimer = RestartableTimer(const Duration(milliseconds: 200), _resetTooltip);
    }
  }

  ScrollController get enclosingScrollController => widget?.enclosingScrollController;

  @override
  void dispose() {
    _removeTooltip();
    _removeGhost();
    enclosingScrollController?.removeListener(_onEnclosingScrollControllerScrolled);
    super.dispose();
  }

  void _resetTooltip() {
    final RenderBox zoneButtonRenderBox = (widget.key as GlobalKey).currentContext.findRenderObject();
    final Offset zoneButtonCoordinates = zoneButtonRenderBox.localToGlobal(Offset.zero);

    _removeTooltip();

    _enclosingOverlayEntry = OverlayEntry(builder: (context) => tooltip);
    _tooltip = _Tooltip(
      onPressedClose: _removeTooltip,
      pressedInfoZoneButtonOffset: zoneButtonCoordinates,
      tooltipHtml: widget.infoZone.tooltipHtml,
      heightOfHtmlContent: ghostHeight,
    );
  }

  void _onEnclosingScrollControllerScrolled() => _afterEnclosingScrollEndedTimer.reset();

  void _removeTooltip() {
    if (_tooltipShouldBeRemoved != true) {
      return;
    }

    _tooltipShouldBeRemoved = false;
    _enclosingOverlayEntry?.remove();
  }

  void _removeGhost() {
    if (_ghostShouldBeRemoved != null) {
      return;
    }

    _ghostShouldBeRemoved = false;
    _ghostInOverlay?.remove();
  }

  @override
  Widget build(BuildContext context) {
    final bubbleText = widget.infoZone.description;
    final onlyOneCharacterShown = bubbleText.characters.length <= 2;
    return _RoundedInfoZoneButton(
      height: _bubbleHeight,
      onPressed: () {
        Overlay.of(context).insert(_enclosingOverlayEntry);
        _tooltipShouldBeRemoved = true;
      },
      child: Stack(
        children: [
          Image.asset(AssetPaths.knowHowFridgeInfoZonesBubbleImage),
          Center(
            child: Padding(
              padding: EdgeInsets.only(bottom: onlyOneCharacterShown ? 5 : 0),
              child: Text(
                bubbleText,
                style: Theme.of(context)
                    .textTheme
                    .bodyText2
                    .copyWith(color: BamColorPalette.bamWhite, fontSize: onlyOneCharacterShown ? 24 : 16),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _Tooltip extends StatelessWidget {
  const _Tooltip({
    Key key,
    @required this.pressedInfoZoneButtonOffset,
    @required this.onPressedClose,
    @required this.tooltipHtml,
    @required this.heightOfHtmlContent,
  })  : assert(onPressedClose != null),
        assert(pressedInfoZoneButtonOffset != null),
        assert(tooltipHtml != null),
        assert(heightOfHtmlContent != null),
        super(key: key);

  final Offset pressedInfoZoneButtonOffset;
  final VoidCallback onPressedClose;
  final String tooltipHtml;
  final double heightOfHtmlContent;

  @override
  Widget build(BuildContext context) {
    final Offset zoneButtonCoordinates = pressedInfoZoneButtonOffset;

    final double marginTooltipToButton = _getScaledToDisplayWithReference(18);
    final double infoBoxTriangleHeight = _getScaledToDisplayWithReference(17.68);
    final double infoBoxHeight = heightOfHtmlContent + infoBoxTriangleHeight;
    final double closeIconWidth = _getScaledToDisplayWithReference(24);

    final triangleOffset = tooltipTriangleOffset(zoneButtonCoordinates.dx);
    final moveTooltipToTheRight = hasToMoveTooltipToTheRight(triangleOffset);
    final moveToRightSideDistance = moveToTheRightDistance(triangleOffset);

    final neededVerticalSpace = zoneButtonCoordinates.dy - marginTooltipToButton - infoBoxHeight;
    final hasEnoughSpaceOnTop = neededVerticalSpace >= 0;

    final overlayFacingStack = Stack(
      children: [
        Positioned.fill(
          child: ModalBarrier(
            dismissible: false,
            color: Colors.transparent,
          ),
        ),
        Positioned.fill(
          child: GestureDetector(
            onTap: onPressedClose,
          ),
        ),
        Positioned(
          left: tooltipMarginToLeftSideOfScreen,
          top: hasEnoughSpaceOnTop
              ? zoneButtonCoordinates.dy - infoBoxHeight
              : zoneButtonCoordinates.dy + marginTooltipToButton + _bubbleHeight,
          width: tooltipContainerWidth(moveTooltipToTheRight, moveToRightSideDistance),
          height: infoBoxHeight,
          child: TweenAnimationBuilder(
              tween: Tween(begin: 0.0, end: 1.0),
              duration: const Duration(milliseconds: 250),
              builder: (context, value, child) {
                return Opacity(
                  opacity: value,
                  child: Stack(
                    children: [
                      CustomPaint(
                        painter: _TooltipPainter(
                          triggeringBubbleLeftPosition: zoneButtonCoordinates.dx,
                          width: _tooltipWidth,
                          paddingLeft: tooltipPainterPaddingLeft(moveTooltipToTheRight, moveToRightSideDistance),
                          willFitOnTop: hasEnoughSpaceOnTop,
                          triangleHeight: infoBoxTriangleHeight,
                        ),
                        child: Builder(builder: (context) {
                          return Padding(
                            padding: EdgeInsets.fromLTRB(
                              tooltipContentLeftPadding(moveTooltipToTheRight, moveToRightSideDistance),
                              tooltipContentTopPadding,
                              tooltipContentRightPadding,
                              tooltipContentBottomPadding,
                            ),
                            child: HtmlUtils.stringToHtml(
                              context,
                              tooltipHtml,
                              textColor: BamColorPalette.bamWhite,
                            ),
                          );
                        }),
                      ),
                      Align(
                        alignment: Alignment.topRight,
                        child: IconButton(
                          onPressed: onPressedClose,
                          icon: Image.asset(
                            AssetPaths.knowHowFridgeInfoZonesTooltipCloseIcon,
                            width: closeIconWidth,
                            height: closeIconWidth,
                          ),
                        ),
                      ),
                    ],
                  ),
                );
              }),
        ),
      ],
    );
    return overlayFacingStack;
  }

  static double tooltipContainerWidth(bool moveTooltipToTheRight, double moveToRightSideDistance) =>
      moveTooltipToTheRight ? _tooltipWidth + moveToRightSideDistance : _tooltipWidth;

  static final double tooltipContentRightPadding = _getScaledToDisplayWithReference(51);

  static double tooltipPainterPaddingLeft(
    bool moveTooltipToTheRight,
    double moveToRightSideDistance,
  ) =>
      moveTooltipToTheRight ? moveToRightSideDistance : 0.0;

  static double tooltipContentLeftPadding(
    bool moveTooltipToTheRight,
    double moveToRightSideDistance,
  ) =>
      moveTooltipToTheRight ? textPaddingLeft + moveToRightSideDistance : textPaddingLeft;

  static final double tooltipContentTopPadding = _getScaledToDisplayWithReference(18);
  static final double textPaddingLeft = _getScaledToDisplayWithReference(14);
  static final double tooltipContentBottomPadding = _getScaledToDisplayWithReference(19);

  static double moveToTheRightDistance(double triangleOffset) => triangleOffset * 2.5;

  static bool hasToMoveTooltipToTheRight(double triangleOffset) {
    final hasToMoveTooltipToTheRight = triangleOffset >= 0;
    return hasToMoveTooltipToTheRight;
  }

  static double tooltipTriangleOffset(double leftCoordinateOfToolbox) {
    final triangleOffset = (leftCoordinateOfToolbox ?? 0.0) + _bubbleHeight / 2 - _tooltipWidth;
    return triangleOffset;
  }
}

class _TooltipPainter extends CustomPainter {
  _TooltipPainter({
    @required double triggeringBubbleLeftPosition,
    @required this.width,
    @required this.triangleHeight,
    this.paddingLeft = 0,
    this.willFitOnTop = true,
  })  : assert(triggeringBubbleLeftPosition != null),
        triggeringBubbleLeftPosition = triggeringBubbleLeftPosition + triangleHeight,
        assert(width != null);

  final double triggeringBubbleLeftPosition;
  final double width;
  final double paddingLeft;
  final bool willFitOnTop;
  final double triangleHeight;

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..style = PaintingStyle.fill
      ..strokeWidth = 1.0
      ..color = BamColorPalette.bamBlack;

    final height = size.height;
    canvas.drawRRect(
      RRect.fromRectAndRadius(Rect.fromLTWH(paddingLeft, 0, width, height), Radius.circular(8.0)),
      paint,
    );
    final double triangleYStartPosition = willFitOnTop ? height - paint.strokeWidth : 0;

    canvas.drawPath(
      Path()
        ..addPolygon(
          willFitOnTop
              ? [
                  Offset(triggeringBubbleLeftPosition, triangleYStartPosition),
                  Offset(triggeringBubbleLeftPosition - triangleHeight, triangleYStartPosition + triangleHeight),
                  Offset(triggeringBubbleLeftPosition - triangleHeight * 2, triangleYStartPosition),
                ]
              : [
                  Offset(triggeringBubbleLeftPosition, 0),
                  Offset(triggeringBubbleLeftPosition - triangleHeight, triangleYStartPosition - triangleHeight),
                  Offset(triggeringBubbleLeftPosition - triangleHeight * 2, triangleYStartPosition),
                ],
          false,
        ),
      paint,
    );
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => this != oldDelegate;
}

class _RoundedInfoZoneButton extends StatelessWidget {
  const _RoundedInfoZoneButton({Key key, @required this.height, @required this.onPressed, @required this.child})
      : assert(height != null),
        assert(onPressed != null),
        assert(child != null),
        super(key: key);

  final double height;
  final VoidCallback onPressed;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(height),
      child: RawMaterialButton(
        onPressed: onPressed,
        child: child,
      ),
    );
  }
}
