import 'dart:io';

import 'package:intl/intl.dart';
import 'package:spreadsheet_decoder/spreadsheet_decoder.dart';
import 'package:tnt_scanner/models/barcode.dart';
import 'package:tnt_scanner/util/common.dart';
import 'package:tnt_scanner/util/constant.dart';

class HomeService {
  String _username;

  List<Barcode> _scannedBarcodes = [];
  List<Barcode> _selectedBarcodes = [];
  List<Barcode> _masterBarcodes = [];

  List<Barcode> get scannedBarcodes => _scannedBarcodes;
  List<Barcode> get selectedBarcodes => _selectedBarcodes;
  List<Barcode> get masterBarcodes => _masterBarcodes;

  String get getUsername => _username;

  setUsername(String username) {
    if (username.isNotEmpty) {
      _username = username[0].toUpperCase() +
          username.substring(1); //Uppercase the first character
    }
  }

  //Check if barcode is available in Master Data
  bool isBarcodeAvailableInMasterBarcodes(String barcode) {
    if (_masterBarcodes.isNotEmpty) {
      for (Barcode masterBarcode in _masterBarcodes) {
        if (removeSuffix(barcode) == masterBarcode.barcode) {
          return true;
        }
      }
    }
    return false;
  }

  //Update Master Data barcode status to "Received"
  checkUpdateMasterBarcodes() {
    if (_masterBarcodes.isNotEmpty) {
      for (Barcode barcode in _scannedBarcodes) {
        for (Barcode masterBarcode in _masterBarcodes) {
          if (barcode.barcode == masterBarcode.barcode) {
            barcode.status = "Received";
            masterBarcode.status = "Received";
          }
        }
      }
    }
  }

  int checkReceivedMasterBarcodes() {
    int _received = 0;

    for (Barcode masterBarcode in _masterBarcodes) {
      if (masterBarcode.status == "Received") {
        _received++;
      }
    }

    return _received;
  }

  //Download data to 'barcode-output' excel file
  downloadSelectedBarcode() {
    int maxRow;
    final String outputTable = kOutputTable;

    var file = '/storage/emulated/0/$kFileName.xlsx';
    var bytes = File(file).readAsBytesSync();
    var decoder = SpreadsheetDecoder.decodeBytes(bytes, update: true);

    maxRow = decoder.tables[outputTable].rows.length;

    for (var barcode in selectedBarcodes) {
      decoder
        ..insertRow(outputTable, maxRow)
        ..updateCell(outputTable, 0, maxRow, maxRow)
        ..updateCell(outputTable, 1, maxRow, barcode.barcode)
        ..updateCell(outputTable, 2, maxRow, barcode.scannedDate)
        ..updateCell(outputTable, 3, maxRow,
            barcode.status == '' ? 'Not found' : barcode.status)
        ..updateCell(outputTable, 4, maxRow,
            DateFormat.yMd().add_jms().format(DateTime.now()));

      maxRow++;
    }

    File(file)
      ..createSync(recursive: true)
      ..writeAsBytesSync(decoder.encode());

    print('Donwloaded');
  }

  //Upload data from 'barcode-input' excel file
  uploadMasterData() {
    //clear master barcode
    _masterBarcodes.clear();

    var file = '/storage/emulated/0/$kFileName.xlsx';
    var bytes = File(file).readAsBytesSync();
    var decoder = SpreadsheetDecoder.decodeBytes(bytes, update: true);
    //Only read the 'input' sheet or table
    for (var row in decoder.tables[kInputTable].rows) {
      for (var cell in row) {
        print(cell);
        _masterBarcodes.add(Barcode(barcode: cell, status: "Not available"));
      }
    }
    //remove the column name "Barcode" in the table
    _masterBarcodes.removeAt(0);
  }

  //Add code to scanned barcodes
  void addScannedCode(String code) {
    scannedBarcodes.insert(
      0,
      Barcode(
        barcode: removeSuffix(code),
        scannedDate: DateFormat.yMd().add_jms().format(DateTime.now()),
        status: "",
      ),
    );

    checkUpdateMasterBarcodes();
  }

  void addSelectedCode(Barcode barcode) {
    _selectedBarcodes.add(barcode);
  }

  void removeSelectedCode(Barcode barcode) {
    _selectedBarcodes.remove(barcode);
  }
}
