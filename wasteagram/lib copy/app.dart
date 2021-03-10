import 'package:flutter/material.dart';
import 'package:wasteagram/screens/list_screen.dart';

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData.dark(),
      home: ListScreen(),
    );
  }
}
