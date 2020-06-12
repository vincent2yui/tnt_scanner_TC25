import 'package:flutter/material.dart';

class SnackBarAlert extends StatelessWidget {
  SnackBarAlert({@required this.icon, @required this.content});

  final Icon icon;
  final String content;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: <Widget>[
        icon,
        SizedBox(width: 10),
        Text(content),
      ],
    );
  }
}
