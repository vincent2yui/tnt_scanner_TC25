import 'package:flutter/material.dart';
import 'package:states_rebuilder/states_rebuilder.dart';
import 'package:tnt_scanner/services/home_service.dart';
import 'package:tnt_scanner/util/app_localizations.dart';
import 'package:tnt_scanner/util/constant.dart';
import 'package:tnt_scanner/widgets/alert_dialog.dart';
import 'package:tnt_scanner/widgets/snack_bar_alert.dart';

class HistoryTab extends StatefulWidget {
  const HistoryTab({
    Key key,
  }) : super(key: key);

  @override
  _HistoryTabState createState() => _HistoryTabState();
}

class _HistoryTabState extends State<HistoryTab>
    with AutomaticKeepAliveClientMixin {
  bool sortBarcode;
  bool sortScannedDate;
  bool sortStatus;

  @override
  bool get wantKeepAlive => true;

  @override
  void initState() {
    super.initState();

    sortBarcode = false;
    sortScannedDate = false;
    sortStatus = false;
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);

    final homeService = Injector.getAsReactive<HomeService>(context: context);

    return Scaffold(
      floatingActionButton: FloatingButton(),
      appBar: AppBar(
        brightness: Brightness.light,
        automaticallyImplyLeading: false,
        title: Text(AppLocalizations.of(context).translate('title tab0')),
      ),
      body: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: SingleChildScrollView(
          scrollDirection: Axis.vertical,
          child: DataTable(
            sortAscending: !sortBarcode,
            sortColumnIndex: 0,
            columns: [
              //Barcode
              DataColumn(
                label: Text(
                  AppLocalizations.of(context).translate('gridColumn0'),
                  style: TextStyle(fontSize: 18),
                ),
                onSort: (columnIndex, ascending) {
                  setState(() {
                    sortBarcode = !sortBarcode;
                  });
                  if (columnIndex == 0) {
                    if (ascending) {
                      homeService.state.scannedBarcodes
                          .sort((a, b) => a.barcode.compareTo(b.barcode));
                    } else {
                      homeService.state.scannedBarcodes
                          .sort((a, b) => b.barcode.compareTo(a.barcode));
                    }
                  }
                },
              ),
              //Status
              DataColumn(
                label: Text(
                    AppLocalizations.of(context).translate('gridColumn1'),
                    style: TextStyle(fontSize: 18)),
                onSort: (columnIndex, ascending) {
                  setState(() {
                    if (sortStatus) {
                      homeService.state.scannedBarcodes
                          .sort((a, b) => a.status.compareTo(b.status));
                    } else {
                      homeService.state.scannedBarcodes
                          .sort((a, b) => b.status.compareTo(a.status));
                    }
                    sortStatus = !sortStatus;
                  });
                },
              ),
              //Date
              DataColumn(
                  label: Text(
                      AppLocalizations.of(context).translate('gridColumn2'),
                      style: TextStyle(fontSize: 18)),
                  onSort: (columnIndex, ascending) {
                    setState(() {
                      if (sortScannedDate) {
                        homeService.state.scannedBarcodes.sort(
                            (a, b) => a.scannedDate.compareTo(b.scannedDate));
                      } else {
                        homeService.state.scannedBarcodes.sort(
                            (a, b) => b.scannedDate.compareTo(a.scannedDate));
                      }
                      sortScannedDate = !sortScannedDate;
                    });
                  }),
            ],
            rows: homeService.state.scannedBarcodes
                .map(
                  (code) => DataRow(
                    selected: homeService.state.selectedBarcodes.contains(code),
                    onSelectChanged: (selected) {
                      if (selected) {
                        homeService.setState(
                          (state) => state.addSelectedCode(code),
                        );
                      } else {
                        homeService.setState(
                          (state) => state.removeSelectedCode(code),
                        );
                      }
                    },
                    cells: [
                      DataCell(Align(
                          child: Text(
                        code.barcode,
                        style: TextStyle(fontSize: 18),
                      ))),
                      DataCell(
                        Align(
                          child: Container(
                            child: code.status == 'Received'
                                ? Icon(
                                    Icons.check_circle,
                                    color: Colors.green,
                                  )
                                : Icon(
                                    Icons.error,
                                    color: Colors.red,
                                  ),
                          ),
                        ),
                      ),
                      DataCell(Align(
                          child: Text(
                        code.scannedDate,
                        style: TextStyle(fontSize: 18),
                      ))),
                    ],
                  ),
                )
                .toList(),
          ),
        ),
      ),
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
    final homeService = Injector.getAsReactive<HomeService>(context: context);

    return FloatingActionButton(
      backgroundColor: kPrimaryColor,
      child: Icon(
        Icons.file_download,
        color: Theme.of(context).scaffoldBackgroundColor,
      ),
      tooltip: AppLocalizations.of(context).translate('tooltip01'),
      onPressed: () {
        if (homeService.state.selectedBarcodes.isNotEmpty) {
          homeService.setState((state) => state.downloadSelectedBarcode());

          final int numberSelectedBarcodes =
              homeService.state.selectedBarcodes.length;

          final snackBar = SnackBar(
            behavior: SnackBarBehavior.floating,
            content: SnackBarAlert(
              icon: Icon(
                Icons.check_circle_outline,
                color: kPrimaryColor,
              ),
              content: '$numberSelectedBarcodes ' +
                  AppLocalizations.of(context)
                      .translate('snackbarAlert download'),
            ),
          );
          Scaffold.of(context).showSnackBar(snackBar);
        } else {
          showAlertDialog(
              context,
              AppLocalizations.of(context).translate('alertDialog title tab0'),
              AppLocalizations.of(context)
                  .translate('alertDialog message tab0'));
        }
      },
    );
  }
}
