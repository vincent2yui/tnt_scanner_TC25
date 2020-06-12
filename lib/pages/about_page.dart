import 'package:flutter/material.dart';
import 'package:tnt_scanner/util/app_localizations.dart';

class AboutPage extends StatelessWidget {
  const AboutPage({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('About'),
      ),
      body: Container(
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Container(
                height: 100,
                child: Image(image: AssetImage('assets/dcs_about.png')),
              ),
              SizedBox(height: 1),
              Text(
                AppLocalizations.of(context).translate('company name'),
                style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.w900,
                ),
              ),
              SizedBox(height: 1),
              Text(
                AppLocalizations.of(context).translate('company motto'),
                style: TextStyle(
                    color: Colors.red,
                    fontSize: 14,
                    fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 30),
              Text(
                AppLocalizations.of(context).translate('company details1'),
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.w600,
                ),
              ),
              SizedBox(height: 5),
              Text(
                AppLocalizations.of(context).translate('company details2'),
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.w400,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
