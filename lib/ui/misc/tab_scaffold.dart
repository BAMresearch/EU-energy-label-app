/* * Copyright 2020 Bundesanstalt für Materialforschung und -prüfung (BAM) *
* Licensed under the EUPL, Version 1.2 or – as soon they will be approved by the European Commission - subsequent versions of the EUPL (the "Licence");
* You may not use this work except in compliance with theLicence.
* You may obtain a copy of the Licence at:
* * https://joinup.ec.europa.eu/software/page/eupl *
* Unless required by applicable law or agreed to in writing, software distributed under the Licence is distributed on an "AS IS" basis,
* WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
* See the Licence for the specific language governing permissions and limitations under the Licence.*/

import 'package:energielabel_app/ui/misc/tab_specification.dart';
import 'package:energielabel_app/ui/misc/theme/bam_colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_fimber/flutter_fimber.dart';
import 'package:flutter_svg/flutter_svg.dart';

class TabScaffold extends StatefulWidget {
  const TabScaffold({@required this.tabSpecifications}) : assert(tabSpecifications != null);

  final List<TabSpecification> tabSpecifications;

  @override
  State<StatefulWidget> createState() => TabScaffoldState();

  static TabScaffoldState of(BuildContext context) {
    return context.findAncestorStateOfType<TabScaffoldState>();
  }
}

class TabScaffoldState extends State<TabScaffold> {
  int _currentIndex = 0;
  List<Widget> _tabNavigators;

  @override
  void initState() {
    _tabNavigators = List.filled(widget.tabSpecifications.length, SizedBox.shrink());
    _tabNavigators[0] = Navigator(
      key: widget.tabSpecifications[0].tabNavigatorKey,
      onGenerateRoute: widget.tabSpecifications[0].onGenerateRoute,
    );
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: _onWillPop,
      child: Scaffold(
        body: IndexedStack(
          index: _currentIndex,
          children: _tabNavigators,
        ),
        bottomNavigationBar: _buildBottomNavigationBar(),
      ),
    );
  }

  Widget _buildBottomNavigationBar() {
    const double fontSize = 13;

    return BottomNavigationBar(
      type: BottomNavigationBarType.fixed,
      currentIndex: _currentIndex,
      backgroundColor: BamColorPalette.bamWhite,
      unselectedItemColor: BamColorPalette.bamBlack60Optimized,
      selectedItemColor: BamColorPalette.bamBlue1Optimized,
      selectedIconTheme: IconThemeData(color: BamColorPalette.bamBlue1Optimized),
      unselectedFontSize: fontSize,
      selectedFontSize: fontSize,
      items: widget.tabSpecifications
          .map(
            (tabSpec) => BottomNavigationBarItem(
                icon: Padding(
                  padding: const EdgeInsets.only(bottom: 4),
                  child: SvgPicture.asset(
                    tabSpec.iconAssetPath,
                    color: widget.tabSpecifications[_currentIndex] == tabSpec
                        ? BamColorPalette.bamBlue1Optimized
                        : BamColorPalette.bamBlack60Optimized,
                  ),
                ),
                label: tabSpec.label),
          )
          .toList(),
      onTap: (index) {
        if (_currentIndex == index) {
          Fimber.d('tabNavigator.popToRoot');
          widget.tabSpecifications[_currentIndex].tabNavigatorKey.currentState.popUntil((route) => route.isFirst);
        }

        if (_tabNavigators[index] is! Navigator) {
          _initializeTab(index);
        }

        setState(() => _currentIndex = index);
      },
    );
  }

  Future<bool> _onWillPop() async {
    final tabNavigator = widget.tabSpecifications[_currentIndex].tabNavigatorKey.currentState;
    if (tabNavigator.canPop()) {
      tabNavigator.pop();
      return false;
    }

    if (_currentIndex == 0) {
      return true;
    }

    setState(() {
      _currentIndex = 0;
    });

    return false;
  }

  TabSpecification currentTabSpecification() {
    return widget.tabSpecifications[_currentIndex];
  }

  void navigateIntoTab(Type tabSpecification, String routeName, {Object routeArguments}) {
    final newTabIndex = widget.tabSpecifications.indexWhere((tabElement) => tabElement.runtimeType == tabSpecification);

    setState(() {
      _tabNavigators[newTabIndex] = SizedBox();
    });

    WidgetsBinding.instance.addPostFrameCallback((_) {
      _initializeTab(newTabIndex, routeName: routeName, routeArguments: routeArguments);

      setState(() {
        _currentIndex = newTabIndex;
      });
    });
  }

  void _initializeTab(int index, {String routeName = Navigator.defaultRouteName, Object routeArguments}) {
    _tabNavigators[index] = Navigator(
      key: widget.tabSpecifications[index].tabNavigatorKey,
      initialRoute: routeName,
      onGenerateInitialRoutes: (NavigatorState navigator, String initialRoute) {
        final List<Route<dynamic>> result = <Route<dynamic>>[];

        if (routeName.startsWith(Navigator.defaultRouteName) && routeName.length > 1) {
          routeName = routeName.substring(1);
          result.add(widget.tabSpecifications[index]
              .onGenerateRoute(RouteSettings(name: Navigator.defaultRouteName, arguments: routeArguments)));

          final List<String> routeParts = routeName.split('/');
          if (routeName.isNotEmpty) {
            String routeName = '';
            for (final String part in routeParts) {
              routeName += '/$part';
              result.add(widget.tabSpecifications[index]
                  .onGenerateRoute(RouteSettings(name: routeName, arguments: routeArguments)));
            }
          }
          if (result.last == null) {
            assert(() {
              FlutterError.reportError(
                FlutterErrorDetails(
                    exception: 'Could not navigate to initial route.\n'
                        'The requested route name was: "/$routeName"\n'
                        'There was no corresponding route in the app, and therefore the initial route specified will be '
                        'ignored and "${Navigator.defaultRouteName}" will be used instead.'),
              );
              return true;
            }());
            result.clear();
          }
        } else if (routeName != Navigator.defaultRouteName) {
          result.add(widget.tabSpecifications[index]
              .onGenerateRoute(RouteSettings(name: routeName, arguments: routeArguments)));
        }
        result.removeWhere((Route<dynamic> route) => route == null);
        if (result.isEmpty) {
          result.add(widget.tabSpecifications[index]
              .onGenerateRoute(RouteSettings(name: Navigator.defaultRouteName, arguments: routeArguments)));
        }
        return result;
      },
      onGenerateRoute: widget.tabSpecifications[index].onGenerateRoute,
    );
  }
}
