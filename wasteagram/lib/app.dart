import 'package:flutter/material.dart';
import 'screens/welcome.dart';
import 'screens/entry_lists.dart';
import 'screens/entry_form.dart';
import 'screens/details.dart';
import 'screens/photo_screen.dart';

class MyApp extends StatelessWidget {
  static final routes = {
    '/': (context) => Welcome(),
    'entries': (context) => EntryLists(),
    'pictures': (context) => EntryForm(),
    'wasteDetails': (context) => WasteDetails(),
    'photoScreen': (context) => PhotoScreen()
  };

  @override
  Widget build(BuildContext context) {
    return new MaterialApp(
      theme: ThemeData.dark(),
      title: 'Wastegram',
      routes: routes,
    );
  }
}
