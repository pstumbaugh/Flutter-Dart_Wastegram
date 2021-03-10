import 'package:flutter/material.dart';
import 'dart:io';

class ImageWidget extends StatelessWidget {
  final String imagePath;
  ImageWidget({this.imagePath});

  @override
  Widget build(BuildContext context) {
    return Expanded(child: Image.network('$imagePath'));
  }
}
