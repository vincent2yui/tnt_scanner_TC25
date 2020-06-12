import 'package:flutter/material.dart';

class AdminPage extends StatelessWidget {
  const AdminPage({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: Text("Administrator"),
      ),
      body: Container(
        child: Text("Admin Page"),
      ),
    );
  }
}
