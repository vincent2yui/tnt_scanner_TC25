import 'package:flutter/material.dart';
import 'package:flutter_progress_button/flutter_progress_button.dart';
import 'package:keyboard_visibility/keyboard_visibility.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:states_rebuilder/states_rebuilder.dart';
import 'package:tnt_scanner/routes/router.gr.dart';
import 'package:tnt_scanner/services/login_service.dart';
import 'package:tnt_scanner/services/settings_service.dart';
import 'package:tnt_scanner/util/app_localizations.dart';
import 'package:tnt_scanner/util/constant.dart';
import 'package:tnt_scanner/widgets/alert_dialog.dart';

class LoginFormWidget extends StatefulWidget {
  @override
  _LoginFormWidgetState createState() => _LoginFormWidgetState();
}

class _LoginFormWidgetState extends State<LoginFormWidget> {
  bool _passwordHide = true;

  TextEditingController _usernameTextController;
  TextEditingController _passwordTextController;

  final _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();

    _usernameTextController = TextEditingController();
    _passwordTextController = TextEditingController();

    KeyboardVisibilityNotification().addNewListener(
      onChange: (bool isVisible) {
        Injector.getAsReactive<LoginService>(context: context).setState(
          (state) => state.setKeyboardVisibility(isVisible),
        );
      },
    );
  }

  @override
  void dispose() {
    super.dispose();
    _usernameTextController.dispose();
    _passwordTextController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final loginModel = Injector.getAsReactive<LoginService>(context: context);
    final settingsModel =
        Injector.getAsReactive<SettingsService>(context: context);

    return Container(
      height: 350,
      width: 280,
      child: Card(
        elevation: 5,
        margin: EdgeInsets.only(top: 50, bottom: 15),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        child: Form(
          key: _formKey,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: <Widget>[
              Container(
                width: kLoginWidgetWidth,
                child: TextFormField(
                  controller: _usernameTextController,
                  keyboardType: TextInputType.visiblePassword,
                  enableInteractiveSelection: false,
                  style: kLoginPageTextFieldTextStyle,
                  validator: (username) {
                    if (username.isEmpty) {
                      return AppLocalizations.of(context)
                          .translate('usernameError');
                    }
                    return null;
                  },
                  decoration: InputDecoration(
                    labelText:
                        AppLocalizations.of(context).translate('username'),
                    suffixIcon: IconButton(
                      icon: Icon(Icons.clear),
                      onPressed: () {
                        _usernameTextController.clear();
                      },
                    ),
                  ),
                ),
              ),
              Container(
                width: kLoginWidgetWidth,
                child: TextFormField(
                  controller: _passwordTextController,
                  obscureText: _passwordHide,
                  style: kLoginPageTextFieldTextStyle,
                  validator: (password) {
                    if (password.isEmpty) {
                      return AppLocalizations.of(context)
                          .translate('passwordError');
                    }
                    return null;
                  },
                  decoration: InputDecoration(
                    labelText:
                        AppLocalizations.of(context).translate('password'),
                    suffixIcon: IconButton(
                      icon: Icon(
                        _passwordHide ? Icons.visibility_off : Icons.visibility,
                      ),
                      onPressed: () {
                        setState(() {
                          _passwordHide = !_passwordHide;
                        });
                      },
                    ),
                  ),
                ),
              ),
              Container(
                child: ProgressButton(
                  animate: true,
                  color: kPrimaryColor,
                  borderRadius: 30,
                  width: kLoginWidgetWidth,
                  height: kLoginPageButtonHeight,
                  onPressed: () async {
                    await runSignIn(context, loginModel);
                  },
                  defaultWidget: Text(
                      AppLocalizations.of(context).translate('sign in'),
                      style: kLoginPageButtonTextStyle),
                  progressWidget: const CircularProgressIndicator(
                      valueColor: AlwaysStoppedAnimation<Color>(Colors.white)),
                ),
              ),
              Container(
                width: kLoginWidgetWidth,
                height: kLoginPageButtonHeight,
                child: RaisedButton(
                  color: Colors.white,
                  shape: RoundedRectangleBorder(
                    side: BorderSide(
                      color: kPrimaryColor,
                      width: 4,
                    ),
                    borderRadius: BorderRadius.circular(30),
                  ),
                  child: Text(
                    AppLocalizations.of(context).translate('language'),
                    style: TextStyle(color: kPrimaryColor, fontSize: 18),
                  ),
                  onPressed: () {
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
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future runSignIn(
      BuildContext context, ReactiveModel<LoginService> loginModel) async {
    if (_formKey.currentState.validate()) {
      FocusScope.of(context).unfocus();

      //Show progress loading button for 750 milliseconds
      await Future.delayed(const Duration(milliseconds: 750), () => 42);

      Map<PermissionGroup, PermissionStatus> permissions =
          await PermissionHandler()
              .requestPermissions([PermissionGroup.storage]);

      if (permissions[PermissionGroup.storage] == PermissionStatus.granted) {
        loginModel.setState(
          (state) => state.uploadLoginMasterData(),
          catchError: true,
          onSetState: (BuildContext context) {
            if (loginModel.hasError) {
              showAlertDialog(
                  context,
                  AppLocalizations.of(context).translate('loginError1 title'),
                  loginModel.error.toString());
            } else {
              if (loginModel.state.checkLoginDetails(
                  _usernameTextController.text, _passwordTextController.text)) {
                Router.navigator.pushReplacementNamed(
                  Router.homePage,
                  arguments:
                      HomePageArguments(username: _usernameTextController.text),
                );
              } else {
                showAlertDialog(
                    context,
                    AppLocalizations.of(context).translate('loginError2 title'),
                    AppLocalizations.of(context)
                        .translate('loginError2 message'));
              }
            }
          },
        );
      }
    }
  }
}
