import 'package:flutter/material.dart';

class Welcome extends StatefulWidget {
  @override
  _WelcomeState createState() => _WelcomeState();
}

class _WelcomeState extends State<Welcome> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Welcome to Wastegram')),
      body: Center(
          child: Container(
              alignment: Alignment(0.0, 0.0),
              child: Column(children: [
                Text('Welcome to Wastegram'),
                nextScreenButton(context)
              ]))),
    );
  }
}

Widget nextScreenButton(BuildContext context) {
  return RaisedButton(
      child: Text('Take me to my home page'),
      onPressed: () {
        Navigator.of(context).pushNamed('entries');
      });
}
