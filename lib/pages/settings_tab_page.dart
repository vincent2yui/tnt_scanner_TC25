import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:states_rebuilder/states_rebuilder.dart';
import 'package:tnt_scanner/routes/router.gr.dart';
import 'package:tnt_scanner/services/settings_service.dart';
import 'package:tnt_scanner/util/app_localizations.dart';
import 'package:tnt_scanner/util/constant.dart';

class SettingsTabPage extends StatefulWidget {
  SettingsTabPage({Key key}) : super(key: key);

  @override
  _SettingsTabPageState createState() => _SettingsTabPageState();
}

class _SettingsTabPageState extends State<SettingsTabPage>
    with AutomaticKeepAliveClientMixin {
  bool _darkMode = false;
  bool _arabic = false;
  bool _keyboardOnScan = false;
  bool _soundOnScan = false;

  @override
  bool get wantKeepAlive => true;

  @override
  Widget build(BuildContext context) {
    super.build(context);

    final settingsModel =
        Injector.getAsReactive<SettingsService>(context: context);

    if (settingsModel.state.appLocal == Locale("ar")) {
      _arabic = true;
    } else {
      _arabic = false;
    }

    return Scaffold(
      appBar: AppBar(
        title: Text(AppLocalizations.of(context).translate('title tab3')),
      ),
      body: SingleChildScrollView(
        child: Container(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              //General
              ListTile(
                  title: Text(
                AppLocalizations.of(context).translate('subtitle01'),
                style:
                    TextStyle(color: Theme.of(context).unselectedWidgetColor),
              )),
              //Arabic Language
              ListTile(
                leading: Icon(Icons.language),
                title: Text(
                  AppLocalizations.of(context).translate('menu01'),
                  style: kSettingsTextStyle,
                ),
                trailing: Switch(
                  activeColor: kPrimaryColor,
                  value: _arabic,
                  onChanged: (bool value) {
                    updateLangauge(context, settingsModel, value);
                  },
                ),
                onTap: () {
                  updateLangauge(context, settingsModel, !_arabic);
                },
              ),
              //Dark Mode
              ListTile(
                leading: Icon(Icons.brightness_4),
                title: Text(
                  AppLocalizations.of(context).translate('menu02'),
                  style: kSettingsTextStyle,
                ),
                trailing: Switch(
                  activeColor: kPrimaryColor,
                  value: _darkMode,
                  onChanged: (bool value) {
                    updateTheme(settingsModel, value);
                  },
                ),
                onTap: () {
                  updateTheme(settingsModel, !_darkMode);
                },
              ),
              Divider(),
              //Scanner Configuration
              ListTile(
                  title: Text(
                AppLocalizations.of(context).translate('subtitle02'),
                style:
                    TextStyle(color: Theme.of(context).unselectedWidgetColor),
              )),
              //Keyboard
              ListTile(
                leading: Icon(Icons.keyboard),
                title: Text(
                  AppLocalizations.of(context).translate('menu03'),
                  style: kSettingsTextStyle,
                ),
                trailing: Switch(
                  activeColor: kPrimaryColor,
                  value: _keyboardOnScan,
                  onChanged: (bool value) {
                    updateKeyboard(settingsModel, value);
                  },
                ),
                onTap: () {
                  updateKeyboard(settingsModel, !_keyboardOnScan);
                },
              ),
              //Sound
              ListTile(
                leading: Icon(Icons.music_note),
                title: Text(
                  AppLocalizations.of(context).translate('menu04'),
                  style: kSettingsTextStyle,
                ),
                trailing: Switch(
                  activeColor: kPrimaryColor,
                  value: _soundOnScan,
                  onChanged: (bool value) {
                    updateSound(settingsModel, value);
                  },
                ),
                onTap: () {
                  updateSound(settingsModel, !_soundOnScan);
                },
              ),
              Divider(),
              //About
              ListTile(
                leading: Icon(Icons.info),
                title: Text(
                  AppLocalizations.of(context).translate('menu05'),
                  style: kSettingsTextStyle,
                ),
                onTap: () {
                  Router.navigator.pushNamed(Router.aboutPage);
                },
              ),
              //Exit the app
              ListTile(
                leading: Icon(Icons.exit_to_app),
                title: Text(
                  AppLocalizations.of(context).translate('menu06'),
                  style: kSettingsTextStyle,
                ),
                onTap: () {
                  SystemNavigator.pop();
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  void updateSound(ReactiveModel<SettingsService> settingsModel, bool value) {
    settingsModel.setState((state) => state.setPlaySound(value));
    setState(() {
      _soundOnScan = value;
    });
  }

  void updateKeyboard(
      ReactiveModel<SettingsService> settingsModel, bool value) {
    settingsModel.setState((state) => state.setShowKeyboard(value));
    setState(() {
      _keyboardOnScan = value;
    });
  }

  void updateTheme(ReactiveModel<SettingsService> settingsModel, bool value) {
    settingsModel.setState((state) => state.setThemeData(value));
    setState(() {
      _darkMode = value;
    });
  }

  void updateLangauge(BuildContext context,
      ReactiveModel<SettingsService> settingsModel, bool value) {
    if (Localizations.localeOf(context).languageCode == "en") {
      //Translate to Arabic
      settingsModel.setState(
        (state) => state.changeLanguage(
          Locale("ar"),
        ),
      );
    } else {
      //Translate to English
      settingsModel.setState(
        (state) => state.changeLanguage(
          Locale("en"),
        ),
      );
    }
    setState(() {
      _arabic = value;
    });
  }
}
