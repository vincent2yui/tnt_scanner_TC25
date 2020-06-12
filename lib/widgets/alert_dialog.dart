import 'package:flutter/material.dart';

Future showAlertDialog(BuildContext context, String title, String content) {
  return showDialog(
    barrierDismissible: true,
    context: context,
    builder: (_) => AlertDialog(
      title: Text(title),
      shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(10.0))),
      content: Text(content),
      // actions: <Widget>[
      //   FlatButton(
      //     child: Text(
      //       'Dismiss',
      //       style: kHomePageAlertDialogTextStyle,
      //     ),
      //     onPressed: () {
      //       Navigator.of(context).pop();
      //     },
      //   ),
      // ],
    ),
  );
}
