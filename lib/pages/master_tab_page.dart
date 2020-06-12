import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:states_rebuilder/states_rebuilder.dart';
import 'package:tnt_scanner/services/home_service.dart';
import 'package:tnt_scanner/util/app_localizations.dart';
import 'package:tnt_scanner/util/constant.dart';
import 'package:tnt_scanner/widgets/snack_bar_alert.dart';

class MasterDataTab extends StatefulWidget {
  const MasterDataTab({
    Key key,
  }) : super(key: key);

  @override
  _MasterDataTabState createState() => _MasterDataTabState();
}

class _MasterDataTabState extends State<MasterDataTab>
    with AutomaticKeepAliveClientMixin {
  @override
  bool get wantKeepAlive => true;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);

    final homeServiceRM = ReactiveModel<HomeService>(context: context);

    return Scaffold(
      appBar: AppBar(
        title: Text(AppLocalizations.of(context).translate('title tab2')),
        automaticallyImplyLeading: false,
      ),
      body: StateBuilder(
        models: [homeServiceRM],
        tag: "masterTab",
        builder: (_, __) {
          if (homeServiceRM.connectionState == ConnectionState.none) {
            return Center(
                //Please upload the database
                child: Text(
                    AppLocalizations.of(context).translate('scaffold body')));
          }

          if (homeServiceRM.connectionState == ConnectionState.waiting) {
            return Center(child: LinearProgressIndicator());
          }

          return ListView.separated(
            itemCount: homeServiceRM.state.masterBarcodes.length,
            separatorBuilder: (_, __) => Divider(),
            itemBuilder: (context, index) {
              return ListTile(
                  leading: Text(
                    '${index + 1}',
                    textAlign: TextAlign.right,
                    style: TextStyle(
                      fontSize: 18,
                      color: Theme.of(context).unselectedWidgetColor,
                    ),
                  ),
                  title: Text(
                    '${homeServiceRM.state.masterBarcodes[index].barcode}',
                    textAlign: TextAlign.left,
                    style: TextStyle(fontSize: 20),
                  ),
                  trailing: homeServiceRM.state.masterBarcodes[index].status ==
                          "Received"
                      ? Icon(
                          Icons.check_circle,
                          color: Colors.green,
                        )
                      : Icon(
                          Icons.check_circle,
                          color: Colors.grey[300],
                        ));
            },
          );
        },
      ),
      floatingActionButton: FloatingButton(),
    );
  }
}

class FloatingButton extends StatefulWidget {
  FloatingButton({Key key}) : super(key: key);

  @override
  _FloatingButtonState createState() => _FloatingButtonState();
}

class _FloatingButtonState extends State<FloatingButton> {
  @override
  Widget build(BuildContext context) {
    final homeServiceRM = Injector.getAsReactive<HomeService>(context: context);

    return FloatingActionButton(
      backgroundColor: kPrimaryColor,
      child: Icon(
        Icons.file_upload,
        color: Theme.of(context).scaffoldBackgroundColor,
      ),
      tooltip: AppLocalizations.of(context).translate('tooltip02'),
      onPressed: () async {
        Map<PermissionGroup, PermissionStatus> permissions =
            await PermissionHandler()
                .requestPermissions([PermissionGroup.storage]);

        if (permissions[PermissionGroup.storage] == PermissionStatus.granted) {
          if (homeServiceRM.state.masterBarcodes.isEmpty) {
            homeServiceRM.setState(
              (state) => state.uploadMasterData(),
              filterTags: [
                "masterTab",
              ],
            );
            showSnackBarAlert(context, homeServiceRM);
          } else {
            showAlertDialog(context, homeServiceRM);
          }
        }
      },
    );
  }

  Future showAlertDialog(
      BuildContext context, ReactiveModel<HomeService> homeServiceRM) {
    return showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: Text(
            AppLocalizations.of(context).translate('alertDialog title tab2')),
        content: Text(
            AppLocalizations.of(context).translate('alertDialog message tab2')),
        actions: <Widget>[
          FlatButton(
            onPressed: () {
              Navigator.of(context).pop();
            },
            child: Text(
                AppLocalizations.of(context)
                    .translate('alertDialog action01 tab2'),
                style: kHomePageAlertDialogTextStyle),
          ),
          FlatButton(
            onPressed: () {
              homeServiceRM.setState(
                (state) => state.uploadMasterData(),
                filterTags: [
                  "masterTab",
                ],
              );
              Navigator.of(context).pop();

              showSnackBarAlert(context, homeServiceRM);
            },
            child: Text(
                AppLocalizations.of(context)
                    .translate('alertDialog action02 tab2'),
                style: kHomePageAlertDialogTextStyle),
          ),
        ],
      ),
    );
  }

  ScaffoldFeatureController<SnackBar, SnackBarClosedReason> showSnackBarAlert(
      BuildContext context, ReactiveModel<HomeService> homeServiceRM) {
    final int numberMasterBarcodes = homeServiceRM.state.masterBarcodes.length;
    return Scaffold.of(context).showSnackBar(
      SnackBar(
        behavior: SnackBarBehavior.floating,
        content: SnackBarAlert(
          icon: Icon(
            Icons.check_circle_outline,
            color: kPrimaryColor,
          ),
          content: '$numberMasterBarcodes ' +
              AppLocalizations.of(context).translate('snackbarAlert upload'),
        ),
      ),
    );
  }
}
