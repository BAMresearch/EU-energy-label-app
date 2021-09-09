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

/// Scaffold providing the application's tab-based root layout.
///
/// The scaffold provides a bottom navigation bar and an area for the tab views.
/// Both, the navigation bar and the content area are filled with data provided
/// by the given list of [TabSpecification].
///
/// In order to programmatically navigate from one tab the another callers can use
/// TabScaffold.of(context).navigateIntoTab().
class TabScaffold extends StatefulWidget {
  const TabScaffold({required this.tabSpecifications});

  final List<TabSpecification> tabSpecifications;

  @override
  State<StatefulWidget> createState() => TabScaffoldState();

  static TabScaffoldState? of(BuildContext context) {
    return context.findAncestorStateOfType<TabScaffoldState>();
  }
}

class TabScaffoldState extends State<TabScaffold> {
  int _currentIndex = 0;
  late List<Widget> _tabNavigators;

  @override
  void initState() {
    // The tab pages shall only be build once first accessed.
    // Therefore, initially the list is filled up with placeholder widgets.
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
        // If the user tapped the already active tab, pop its stack to the root page.
        if (_currentIndex == index) {
          Fimber.d('tabNavigator.popToRoot');
          widget.tabSpecifications[_currentIndex].tabNavigatorKey.currentState!.popUntil((route) => route.isFirst);
        }

        if (_tabNavigators[index] is! Navigator) {
          _initializeTab(index);
        }

        setState(() => _currentIndex = index);
      },
    );
  }

  Future<bool> _onWillPop() async {
    final tabNavigator = widget.tabSpecifications[_currentIndex].tabNavigatorKey.currentState!;
    if (tabNavigator.canPop()) {
      tabNavigator.pop();
      return false;
    }

    if (_currentIndex == 0) {
      // We are on start already. We will exit the app.
      return true;
    }

    // we are not yet on the start page. As the navigation stack of the current tab is empty, we will
    // switch to the start page tab.

    setState(() {
      _currentIndex = 0;
    });

    return false;
  }

  TabSpecification currentTabSpecification() {
    return widget.tabSpecifications[_currentIndex];
  }

  /// Switches the tab selection to the given TabSpecification and navigates in that tab to
  /// the location specified as
  void navigateIntoTab(Type? tabSpecification, String? routeName, {Object? routeArguments}) {
    final newTabIndex = widget.tabSpecifications.indexWhere((tabElement) => tabElement.runtimeType == tabSpecification);

    // Remove the previous navigator from the tree so that the new one is treated as a new one, meaning
    // that the new navigator's initState is executed and the initial route interpreted again.
    setState(() {
      _tabNavigators[newTabIndex] = SizedBox();
    });

    WidgetsBinding.instance!.addPostFrameCallback((_) {
      _initializeTab(newTabIndex, routeName: routeName, routeArguments: routeArguments);

      setState(() {
        _currentIndex = newTabIndex;
      });
    });
  }

  void _initializeTab(int index, {String? routeName = Navigator.defaultRouteName, Object? routeArguments}) {
    // Replace it with the tab's navigator now.
    _tabNavigators[index] = Navigator(
      key: widget.tabSpecifications[index].tabNavigatorKey,
      initialRoute: routeName,
      onGenerateInitialRoutes: (NavigatorState navigator, String initialRoute) {
        final List<Route<dynamic>> result = <Route<dynamic>>[];

        if (routeName!.startsWith(Navigator.defaultRouteName) && routeName!.length > 1) {
          routeName = routeName!.substring(1); // strip leading '/'
          result.add(widget.tabSpecifications[index]
              .onGenerateRoute(RouteSettings(name: Navigator.defaultRouteName, arguments: routeArguments))!);

          final List<String> routeParts = routeName!.split('/');
          if (routeName!.isNotEmpty) {
            String routeName = '';
            for (final String part in routeParts) {
              routeName += '/$part';
              result.add(widget.tabSpecifications[index]
                  .onGenerateRoute(RouteSettings(name: routeName, arguments: routeArguments))!);
            }
          }
        } else if (routeName != Navigator.defaultRouteName) {
          // If routeName wasn't '/', then we try to get it with allowNull:true, so that if that fails,
          // we fall back to '/' (without allowNull:true, see below).
          result.add(widget.tabSpecifications[index]
              .onGenerateRoute(RouteSettings(name: routeName, arguments: routeArguments))!);
        }
        // Null route might be a result of gap in routeName
        //
        // For example, routes = ['A', 'A/B/C'], and routeName = 'A/B/C'
        // This should result in result = ['A', null,'A/B/C'] where 'A/B' produces
        // the null. In this case, we want to filter out the null and return
        // result = ['A', 'A/B/C'].
        result.removeWhere((Route<dynamic>? route) => route == null);
        if (result.isEmpty) {
          result.add(widget.tabSpecifications[index]
              .onGenerateRoute(RouteSettings(name: Navigator.defaultRouteName, arguments: routeArguments))!);
        }
        return result;
      },
      onGenerateRoute: widget.tabSpecifications[index].onGenerateRoute,
    );
  }
}
