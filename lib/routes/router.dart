import 'package:auto_route/auto_route_annotations.dart';
import 'package:auto_route/transitions_builders.dart';
import 'package:tnt_scanner/pages/about_page.dart';
import 'package:tnt_scanner/pages/admin_page.dart';
import 'package:tnt_scanner/pages/home_page.dart';
import 'package:tnt_scanner/pages/login_page.dart';

@autoRouter
class $Router {
  @initial
  LoginPage loginPage;
  @CustomRoute(
      transitionsBuilder: TransitionsBuilders.slideLeft,
      durationInMilliseconds: 450)
  HomePage homePage;
  AdminPage adminPage;
  @CustomRoute(transitionsBuilder: TransitionsBuilders.slideLeft)
  AboutPage aboutPage;
}

// flutter pub run build_runner watch --delete-conflicting-outputs
