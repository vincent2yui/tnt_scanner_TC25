import 'package:flutter/material.dart';

const String kSuffix = ',';
const String kFileName = 'barcode';
const String kInputTable = 'input';
const String kOutputTable = 'output';
const String kPasswordTable = 'password';

const kColorWhite = Color(0xFFF2F2F2);
const kColorOrange = Color(0xFFF96D00);
const kColorGrey = Color(0xFF393E46);
const kColorBlack = Color(0xFF222831);

const kPrimaryColor = Color(0xFFF96D00);
const kAccentColor = Colors.indigoAccent;
const kBody1Color = Color(0xFF393E46);
const kBody2Color = Color(0xFF222831);
const kScaffoldBackgroundColor = Color(0xFFF96D00);

const kKeyboardAnimationDuration = 400;
const double kLoginWidgetWidth = 250;
const double kLoginPageButtonHeight = 45;
const double kBottomNavigationIconSize = 20;

const kHomePageAlertDialogTextStyle =
    TextStyle(color: kPrimaryColor, fontSize: 18);

const kLoginPageTextFieldTextStyle = TextStyle(
  fontSize: 18,
);

const kLoginPageButtonTextStyle = TextStyle(
  color: Colors.white,
  fontSize: 18,
);

const kSettingsTextStyle = TextStyle(
  fontSize: 18,
);

const kCompanyLogoBoxDecoration = BoxDecoration(
  image: DecorationImage(image: AssetImage('assets/company_logo.png')),
  gradient: LinearGradient(
    begin: Alignment.topRight,
    end: Alignment.bottomLeft,
    colors: [Colors.red, kPrimaryColor],
  ),
);
