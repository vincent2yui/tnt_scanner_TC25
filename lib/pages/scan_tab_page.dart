import 'package:audioplayers/audio_cache.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:keyboard_visibility/keyboard_visibility.dart';
import 'package:states_rebuilder/states_rebuilder.dart';
import 'package:tnt_scanner/services/home_service.dart';
import 'package:tnt_scanner/services/settings_service.dart';
import 'package:tnt_scanner/util/common.dart';
import 'package:tnt_scanner/util/constant.dart';
import 'package:tnt_scanner/widgets/alert_dialog.dart';

class ScanCodeTab extends StatefulWidget {
  ScanCodeTab({Key key}) : super(key: key);

  @override
  _ScanCodeTabState createState() => _ScanCodeTabState();
}

class _ScanCodeTabState extends State<ScanCodeTab> {
  // with AutomaticKeepAliveClientMixin {
  final TextEditingController _textController = TextEditingController();
  final settingsModelOutside = Injector.getAsReactive<SettingsService>();

  FocusNode _textFieldFocusNode;
  Color _textBorder = Colors.orange[200]; //Colors.grey;
  Color _backgroundColor = kPrimaryColor; //Colors.grey[350];
  String _code;

  // @override
  // bool get wantKeepAlive => true;

  @override
  void initState() {
    super.initState();

    _textFieldFocusNode = FocusNode();
    autoFocusTextField();
    keyboardListenerHideOnShow();
  }

  @override
  void dispose() {
    super.dispose();

    _textController.dispose();
    _textFieldFocusNode.dispose();
  }

  void autoFocusTextField() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      FocusScope.of(context).requestFocus(_textFieldFocusNode);
      if (!settingsModelOutside.state.showKeyboard) {
        print('keyboard is ON');
        SystemChannels.textInput.invokeMethod('TextInput.hide');
      }
    });
  }

  void keyboardListenerHideOnShow() {
    KeyboardVisibilityNotification().addNewListener(
      onChange: (bool visible) {
        //hide on-show keyboard
        if (visible) {
          if (!settingsModelOutside.state.showKeyboard) {
            print('keyboard is ON');
            SystemChannels.textInput.invokeMethod('TextInput.hide');
          }
        }
      },
    );
  }

  void updateHomeColor(bool isFound, bool isPlaySound) {
    if (isFound) {
      if (isPlaySound) {
        playSound('success');
      }
      _textBorder = Colors.green[200];
      _backgroundColor = Colors.green[700];
    } else {
      if (isPlaySound) {
        playSound('error');
      }
      _textBorder = Colors.red[200];
      _backgroundColor = Colors.red[700];
    }
  }

  void playSound(String soundStatus) async {
    final player = AudioCache();
    await player.play('$soundStatus.wav');
  }

  @override
  Widget build(BuildContext context) {
    // super.build(context);

    final homeModel = Injector.getAsReactive<HomeService>(context: context);
    final settingsModel =
        Injector.getAsReactive<SettingsService>(context: context);

    return Scaffold(
      backgroundColor: _backgroundColor,
      resizeToAvoidBottomInset: false,
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          Expanded(
            child: Align(
              alignment: Alignment.center,
              child: AbsorbPointer(
                absorbing: !settingsModel.state.showKeyboard,
                child: Container(
                  width: 300,
                  child: TextField(
                    cursorColor: _textBorder,
                    controller: _textController,
                    focusNode: _textFieldFocusNode,
                    keyboardType: TextInputType.number,
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 20,
                    ),
                    decoration: InputDecoration(
                      hintText: _code,
                      focusedBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: _textBorder, width: 3),
                        borderRadius: const BorderRadius.all(
                          Radius.circular(20.0),
                        ),
                      ),
                      fillColor: Theme.of(context).scaffoldBackgroundColor,
                      filled: true,
                      border: OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.black, width: 3),
                        borderRadius: const BorderRadius.all(
                          Radius.circular(20.0),
                        ),
                      ),
                    ),
                    onChanged: (inputText) async {
                      if (inputText.contains(kSuffix)) {
                        _code = removeSuffix(inputText);
                        //check if Master Asset is not empty
                        if (homeModel.state.masterBarcodes.isNotEmpty) {
                          homeModel.setState(
                              (state) => state.addScannedCode(inputText));
                          setState(() {
                            updateHomeColor(
                                homeModel.state
                                    .isBarcodeAvailableInMasterBarcodes(
                                        inputText),
                                settingsModel.state.playSound);
                          });
                        } else {
                          showAlertDialog(context, 'Master data is empty!',
                              'Please upload your file before scanning.');
                        }
                        await Future.delayed(Duration(milliseconds: 1));
                        _textController.clear();
                      }
                    },
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
