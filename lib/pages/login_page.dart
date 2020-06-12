import 'package:flutter/material.dart';
import 'package:states_rebuilder/states_rebuilder.dart';
import 'package:tnt_scanner/services/login_service.dart';
import 'package:tnt_scanner/util/constant.dart';
import 'package:tnt_scanner/widgets/login_form.dart';

class LoginPage extends StatelessWidget {
  const LoginPage({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Injector(
      inject: [
        Inject<LoginService>(() => LoginService(context)),
      ],
      builder: (context) {
        final loginModel =
            Injector.getAsReactive<LoginService>(context: context);
        return Scaffold(
          resizeToAvoidBottomInset: false,
          body: Container(
            child: Stack(
              children: <Widget>[
                Column(
                  children: <Widget>[
                    Expanded(
                        child:
                            Container(decoration: kCompanyLogoBoxDecoration)),
                    Expanded(child: SizedBox()),
                  ],
                ),
                AnimatedAlign(
                  alignment: loginModel.state.keyboardPosition,
                  curve: Curves.easeInOutQuint,
                  duration: Duration(milliseconds: kKeyboardAnimationDuration),
                  child: LoginFormWidget(),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
