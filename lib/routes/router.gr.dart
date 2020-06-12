// GENERATED CODE - DO NOT MODIFY BY HAND

// **************************************************************************
// AutoRouteGenerator
// **************************************************************************

import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:auto_route/router_utils.dart';
import 'package:tnt_scanner/pages/login_page.dart';
import 'package:tnt_scanner/pages/home_page.dart';
import 'package:auto_route/transitions_builders.dart';
import 'package:tnt_scanner/pages/admin_page.dart';
import 'package:tnt_scanner/pages/about_page.dart';

class Router {
  static const loginPage = '/';
  static const homePage = '/home-page';
  static const adminPage = '/admin-page';
  static const aboutPage = '/about-page';
  static GlobalKey<NavigatorState> get navigatorKey =>
      getNavigatorKey<Router>();
  static NavigatorState get navigator => navigatorKey.currentState;

  static Route<dynamic> onGenerateRoute(RouteSettings settings) {
    final args = settings.arguments;
    switch (settings.name) {
      case Router.loginPage:
        if (hasInvalidArgs<Key>(args)) {
          return misTypedArgsRoute<Key>(args);
        }
        final typedArgs = args as Key;
        return MaterialPageRoute(
          builder: (_) => LoginPage(key: typedArgs),
          settings: settings,
        );
      case Router.homePage:
        if (hasInvalidArgs<HomePageArguments>(args)) {
          return misTypedArgsRoute<HomePageArguments>(args);
        }
        final typedArgs = args as HomePageArguments ?? HomePageArguments();
        return PageRouteBuilder(
          pageBuilder: (ctx, animation, secondaryAnimation) =>
              HomePage(typedArgs.username, key: typedArgs.key),
          settings: settings,
          transitionsBuilder: TransitionsBuilders.slideLeft,
          transitionDuration: Duration(milliseconds: 450),
        );
      case Router.adminPage:
        if (hasInvalidArgs<Key>(args)) {
          return misTypedArgsRoute<Key>(args);
        }
        final typedArgs = args as Key;
        return MaterialPageRoute(
          builder: (_) => AdminPage(key: typedArgs),
          settings: settings,
        );
      case Router.aboutPage:
        if (hasInvalidArgs<Key>(args)) {
          return misTypedArgsRoute<Key>(args);
        }
        final typedArgs = args as Key;
        return PageRouteBuilder(
          pageBuilder: (ctx, animation, secondaryAnimation) =>
              AboutPage(key: typedArgs),
          settings: settings,
          transitionsBuilder: TransitionsBuilders.slideLeft,
        );
      default:
        return unknownRoutePage(settings.name);
    }
  }
}

//**************************************************************************
// Arguments holder classes
//***************************************************************************

//HomePage arguments holder class
class HomePageArguments {
  final String username;
  final Key key;
  HomePageArguments({this.username, this.key});
}
