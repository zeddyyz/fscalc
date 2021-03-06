import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fscalc/free/features/chart/chart_screen.dart';
import 'package:fscalc/free/features/forex/screens/forex_screen.dart';
import 'package:fscalc/free/features/settings/screens/settings_screen.dart';
import 'package:fscalc/free/features/stocks/screens/stocks_screen.dart';
import 'package:fscalc/free/utilities/constants.dart';
import 'package:fscalc/paid/authentication/auth_controller.dart';
import 'package:fscalc/paid/home/paid_home.dart';

import 'package:get/get.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:persistent_bottom_nav_bar/persistent-tab-view.dart';

class BottomNav extends StatefulWidget {
  const BottomNav({Key? key}) : super(key: key);

  @override
  _BottomNavState createState() => _BottomNavState();
}

class _BottomNavState extends State<BottomNav> {
  late PersistentTabController _controller;
  final AuthController _authController = Get.put(AuthController());

  @override
  void initState() {
    super.initState();
    _controller = PersistentTabController(initialIndex: 0);
  }

  @override
  void dispose() {
    super.dispose();
  }

  Future<InitializationStatus> _initGoogleMobileAds() {
    return MobileAds.instance.initialize();
  }

  List<Widget> _buildScreens() {
    return _authController.isLoggedIn.isTrue
        ? [
            const ForexScreen(),
            const StocksScreen(),
            const ChartScreen(),
            const SettingsScreen(),
            const PaidHome(),
          ]
        : [
            const ForexScreen(),
            const StocksScreen(),
            const ChartScreen(),
            const SettingsScreen(),
          ];
  }

  List<PersistentBottomNavBarItem> _navBarsItems() {
    return _authController.isLoggedIn.isTrue
        ? [
            PersistentBottomNavBarItem(
              icon: const Icon(CupertinoIcons.money_dollar_circle),
              title: ("Forex"),
              activeColorPrimary: kThemeRed,
              inactiveColorPrimary: CupertinoColors.systemGrey,
            ),
            PersistentBottomNavBarItem(
              icon: const Icon(CupertinoIcons.money_dollar),
              title: ("Stocks"),
              activeColorPrimary: kThemeRed,
              inactiveColorPrimary: CupertinoColors.systemGrey,
            ),
            PersistentBottomNavBarItem(
              icon: const Icon(Icons.analytics_outlined),
              title: ("Info"),
              activeColorPrimary: kThemeRed,
              inactiveColorPrimary: CupertinoColors.systemGrey,
            ),
            PersistentBottomNavBarItem(
              icon: const Icon(CupertinoIcons.settings),
              title: ("Settings"),
              activeColorPrimary: kThemeRed,
              inactiveColorPrimary: CupertinoColors.systemGrey,
            ),
            PersistentBottomNavBarItem(
              icon: const Icon(Icons.assessment),
              title: ("Forex"),
              activeColorPrimary: kThemeRed,
              inactiveColorPrimary: CupertinoColors.systemGrey,
            ),
          ]
        : [
            PersistentBottomNavBarItem(
              icon: const Icon(CupertinoIcons.money_dollar_circle),
              title: ("Forex"),
              activeColorPrimary: kThemeRed,
              inactiveColorPrimary: CupertinoColors.systemGrey,
            ),
            PersistentBottomNavBarItem(
              icon: const Icon(CupertinoIcons.money_dollar),
              title: ("Stocks"),
              activeColorPrimary: kThemeRed,
              inactiveColorPrimary: CupertinoColors.systemGrey,
            ),
            PersistentBottomNavBarItem(
              icon: const Icon(Icons.analytics_outlined),
              title: ("Info"),
              activeColorPrimary: kThemeRed,
              inactiveColorPrimary: CupertinoColors.systemGrey,
            ),
            PersistentBottomNavBarItem(
              icon: const Icon(CupertinoIcons.settings),
              title: ("Settings"),
              activeColorPrimary: kThemeRed,
              inactiveColorPrimary: CupertinoColors.systemGrey,
            ),
          ];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: FutureBuilder<void>(
          future: _initGoogleMobileAds(),
          builder: (BuildContext context, AsyncSnapshot<void> snapshot) {
            return PersistentTabView(
              context,
              controller: _controller,
              screens: _buildScreens(),
              items: _navBarsItems(),
              confineInSafeArea: true,
              backgroundColor: Colors.white,
              handleAndroidBackButtonPress: true,
              resizeToAvoidBottomInset: true,
              stateManagement: true,
              hideNavigationBarWhenKeyboardShows: true,
              decoration: NavBarDecoration(
                borderRadius: BorderRadius.circular(16),
                colorBehindNavBar: Colors.white,
              ),
              popAllScreensOnTapOfSelectedTab: true,
              popActionScreens: PopActionScreensType.all,
              itemAnimationProperties: const ItemAnimationProperties(
                duration: Duration(milliseconds: 200),
                curve: Curves.ease,
              ),
              screenTransitionAnimation: const ScreenTransitionAnimation(
                animateTabTransition: true,
                curve: Curves.ease,
                duration: Duration(milliseconds: 200),
              ),
              navBarStyle: NavBarStyle.style12,
            );
          }),
    );
  }
}
