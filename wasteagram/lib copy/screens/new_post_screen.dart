import 'package:flutter/material.dart';
import 'package:location/location.dart';
import 'package:wasteagram/widgets/form_widget.dart';
import 'package:wasteagram/widgets/image_widget.dart';

// This screen allows a user to upload a new post
class NewPostScreen extends StatefulWidget {
  final String imagePath;
  NewPostScreen({this.imagePath});

  @override
  _NewPostScreenState createState() =>
      _NewPostScreenState(imagePath: imagePath);
}

class _NewPostScreenState extends State<NewPostScreen> {
  LocationData locationData;
  final String imagePath;
  _NewPostScreenState({this.imagePath});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(centerTitle: true, title: const Text('Wastegram')),
      body: Column(mainAxisAlignment: MainAxisAlignment.spaceEvenly, children: [
        ImageWidget(imagePath: imagePath),
        FormWidget(imagePath: imagePath),
      ]),
    );
  }
}
