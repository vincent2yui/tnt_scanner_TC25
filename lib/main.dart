import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:states_rebuilder/states_rebuilder.dart';
import 'package:tnt_scanner/services/settings_service.dart';
import 'package:tnt_scanner/util/app_localizations.dart';
import 'routes/router.gr.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]).then(
    (_) {
      runApp(
        Injector(
          inject: [
            Inject<SettingsService>(() => SettingsService()),
          ],
          builder: (context) {
            final settingsService =
                Injector.getAsReactive<SettingsService>(context: context);

            return MaterialApp(
              debugShowCheckedModeBanner: false,
              //Dynamic Theme Data
              theme: settingsService.state.themeData,
              //Language Translation
              locale: settingsService.state.appLocal,
              supportedLocales: [
                Locale('en', 'US'),
                Locale('ar', ''),
              ],
              localizationsDelegates: [
                AppLocalizations.delegate,
                GlobalMaterialLocalizations.delegate,
                GlobalWidgetsLocalizations.delegate,
              ],
              //Navigator route page
              initialRoute: Router.loginPage,
              onGenerateRoute: Router.onGenerateRoute,
              navigatorKey: Router.navigatorKey,
            );
          },
        ),
      );
    },
  );
}
