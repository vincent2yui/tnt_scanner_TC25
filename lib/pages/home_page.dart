import 'package:badges/badges.dart';
import 'package:double_back_to_close_app/double_back_to_close_app.dart';
import 'package:flutter/material.dart';
import 'package:states_rebuilder/states_rebuilder.dart';
import 'package:tnt_scanner/pages/settings_tab_page.dart';
import 'package:tnt_scanner/services/home_service.dart';
import 'package:tnt_scanner/util/app_localizations.dart';
import 'package:tnt_scanner/util/constant.dart';
import 'package:tnt_scanner/widgets/snack_bar_alert.dart';

import 'history_tab_page.dart';
import 'master_tab_page.dart';
import 'scan_tab_page.dart';

class HomePage extends StatefulWidget {
  HomePage(this.username, {Key key}) : super(key: key);

  final String username;

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _selectedIndex = 2;
  bool _showBadge = false;

  PageController homePageController;

  @override
  void initState() {
    super.initState();

    homePageController = PageController(initialPage: _selectedIndex);
  }

  @override
  void dispose() {
    super.dispose();

    homePageController.dispose();
  }

  void _onPageChanged(int index) {
    setState(() {
      _selectedIndex = index;
      // _badgeNumber++;
      if (index == 2) {
        _showBadge = false;
      } else {
        _showBadge = true;
      }
    });
  }

  void _onItemTapped(int index) {
    homePageController.jumpToPage(index);
  }

  @override
  Widget build(BuildContext context) {
    return Injector(
      inject: [
        Inject<HomeService>(() => HomeService()),
      ],
      builder: (context) {
        final homeServiceRM = ReactiveModel<HomeService>(context: context);

        return SafeArea(
          child: Scaffold(
            resizeToAvoidBottomInset: false,
            body: DoubleBackToCloseApp(
              snackBar: SnackBar(
                content: SnackBarAlert(
                  icon: Icon(Icons.info_outline),
                  content: AppLocalizations.of(context)
                      .translate('snackbarAlert exit'),
                ),
              ),
              child: PageView(
                controller: homePageController,
                physics: NeverScrollableScrollPhysics(),
                children: <Widget>[
                  HistoryTab(),
                  ScanCodeTab(),
                  MasterDataTab(),
                  SettingsTabPage(),
                ],
                onPageChanged: _onPageChanged,
              ),
            ),
            bottomNavigationBar: BottomNavigationBar(
              elevation: 15,
              currentIndex: _selectedIndex,
              unselectedItemColor: Theme.of(context).unselectedWidgetColor,
              selectedItemColor: kPrimaryColor,
              onTap: _onItemTapped,
              items: <BottomNavigationBarItem>[
                //History
                BottomNavigationBarItem(
                  icon: Icon(Icons.history),
                  title: Text(
                    AppLocalizations.of(context)
                        .translate('title bottom nav page0'),
                  ),
                  backgroundColor: Theme.of(context).scaffoldBackgroundColor,
                ),
                //Scan Code
                BottomNavigationBarItem(
                  icon: Icon(Icons.search),
                  title: Text(
                    AppLocalizations.of(context)
                        .translate('title bottom nav page1'),
                  ),
                  backgroundColor: Theme.of(context).scaffoldBackgroundColor,
                ),
                //Database
                BottomNavigationBarItem(
                  icon: Badge(
                    animationType: BadgeAnimationType.scale,
                    showBadge: _showBadge,
                    badgeContent: Text(
                      homeServiceRM.state
                          .checkReceivedMasterBarcodes()
                          .toString(),
                      style: TextStyle(
                          color: Colors.white,
                          fontSize: 8,
                          fontWeight: FontWeight.bold),
                    ),
                    child: Icon(Icons.save),
                  ),
                  title: Text(
                    AppLocalizations.of(context)
                        .translate('title bottom nav page2'),
                  ),
                  backgroundColor: Theme.of(context).scaffoldBackgroundColor,
                ),
                //Settings
                BottomNavigationBarItem(
                  icon: Icon(Icons.settings),
                  title: Text(
                    AppLocalizations.of(context)
                        .translate('title bottom nav page3'),
                  ),
                  backgroundColor: Theme.of(context).scaffoldBackgroundColor,
                )
              ],
            ),
          ),
        );
      },
    );
  }
}
