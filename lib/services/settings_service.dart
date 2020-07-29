import 'package:flutter/material.dart';
import 'package:tnt_scanner/util/constant.dart';

enum MyThemeKeys { OrangeLightTheme, OrangeDarkTime }

class SettingsService {
  ThemeData _preferredTheme = orangeLightTheme;
  Locale _appLocale = Locale('en');
  bool _playSound = false;
  bool _showKeyboard = false;

  get themeData => _preferredTheme;
  get appLocal => _appLocale ?? Locale("en");
  get playSound => _playSound;
  get showKeyboard => _showKeyboard;

  setThemeData(bool isDarkMode) {
    return isDarkMode
        ? _preferredTheme = orangeDarkTheme
        : _preferredTheme = orangeLightTheme;
  }

  changeLanguage(Locale type) async {
    if (_appLocale == type) {
      return;
    }
    if (type == Locale("ar")) {
      _appLocale = Locale("ar");
    } else {
      _appLocale = Locale("en");
    }
  }

  setPlaySound(bool playSound) => _playSound = playSound;

  setShowKeyboard(bool showKeyboard) => _showKeyboard = showKeyboard;

  static final ThemeData orangeLightTheme = ThemeData.light().copyWith(
    appBarTheme: AppBarTheme(
      color: kColorWhite,
      iconTheme: IconThemeData(color: kPrimaryColor),
      textTheme: TextTheme(
        headline6: TextStyle(
          color: kColorBlack,
          fontSize: 20,
          fontWeight: FontWeight.bold,
        ),
      ),
    ),
    scaffoldBackgroundColor: kColorWhite,
    primaryColor: kPrimaryColor,
    accentColor: kAccentColor,
  );

  static final ThemeData orangeDarkTheme = ThemeData.dark().copyWith(
    appBarTheme: AppBarTheme(
      color: kColorBlack,
      iconTheme: IconThemeData(color: kPrimaryColor),
      textTheme: TextTheme(
        headline6: TextStyle(
          color: kColorWhite,
          fontSize: 20,
          fontWeight: FontWeight.bold,
        ),
      ),
    ),
    scaffoldBackgroundColor: kColorBlack,
    primaryColor: kPrimaryColor,
    accentColor: kAccentColor,
  );
}
