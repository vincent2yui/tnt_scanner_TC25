import 'dart:io';

import 'package:flutter/material.dart';
import 'package:spreadsheet_decoder/spreadsheet_decoder.dart';
import 'package:tnt_scanner/models/user.dart';
import 'package:tnt_scanner/util/app_localizations.dart';
import 'package:tnt_scanner/util/constant.dart';
import 'package:tnt_scanner/util/failure.dart';

class LoginService {
  List<User> _users = [];
  User _loginUser;
  bool _isKeyboardVisible = false;
  BuildContext context;

  LoginService(this.context);

  setKeyboardVisibility(bool value) {
    _isKeyboardVisible = value;
    print('Keyboard Visibility is $value');
  }

  get loginUser {
    return _loginUser;
  }

  get keyboardPosition {
    return _isKeyboardVisible ? Alignment.topCenter : Alignment.bottomCenter;
  }

  //Upload login details from Master Data file
  uploadLoginMasterData() {
    try {
      var file = '/storage/emulated/0/$kFileName.xlsx';
      var bytes = File(file).readAsBytesSync();
      var decoder = SpreadsheetDecoder.decodeBytes(bytes, update: true);
      //Only read the 'input' sheet or table
      for (var row in decoder.tables[kPasswordTable].rows) {
        print(row[0]);
        print(row[1]);
        _users.add(User(username: row[0], password: row[1]));
      }
      //remove the columns "usernmae" and "password" in the table
      _users.removeAt(0);
    } on FileSystemException {
      throw Failure(
          AppLocalizations.of(context).translate('loginError1.1 message'));
    } on NoSuchMethodError {
      throw Failure(
          AppLocalizations.of(context).translate('loginError1.2 message'));
    }
  }

  //Verify user login access
  bool checkLoginDetails(String username, String password) {
    _loginUser = User(username: username, password: password);

    return _users.contains(_loginUser);
  }
}
