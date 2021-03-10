import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:location/location.dart';
import 'package:intl/intl.dart';

class FormWidget extends StatefulWidget {
  final String imagePath;
  FormWidget({this.imagePath});
  @override
  _FormWidgetState createState() => _FormWidgetState(imagePath: imagePath);
}

class _FormWidgetState extends State<FormWidget> {
  LocationData locationData;
  final String imagePath;
  int itemCount;
  //Entry entry = Entry();

  _FormWidgetState({this.imagePath});

  // Function will set the locationData var
  retrieveLocation() async {
    var locationService = Location();
    locationData = await locationService.getLocation();
  }

  @override
  Widget build(BuildContext context) {
    final formKey = GlobalKey<FormState>();
    return Form(
        key: formKey,
        child: Column(children: <Widget>[
          TextFormField(
            textAlign: TextAlign.center,
            keyboardType: TextInputType.number,
            decoration:
                const InputDecoration(hintText: 'Number of wasted items'),
            validator: (value) {
              if (value.isEmpty) {
                return 'Please enter a quantity';
              }
              return null;
            },
            onSaved: (value) {
              itemCount = int.parse(value);
              //print(formValue);
            },
          ),
          Align(
            alignment: Alignment.bottomCenter,
            child: SizedBox(
                width: 300,
                height: 75,
                child: Semantics(
                    label: "Submit post",
                    hint: "Submit post",
                    child: RaisedButton(
                      key: Key('submitButton'),
                      onPressed: () async {
                        if (formKey.currentState.validate()) {
                          formKey.currentState.save();
                          // Formate Date
                          String date = DateFormat.yMd().format(DateTime.now());

                          // Get location data
                          await retrieveLocation();
                          StorageReference storageReference = FirebaseStorage
                              .instance
                              .ref()
                              .child(DateTime.now().toString());

                          StorageUploadTask uploadTask =
                              storageReference.putFile(File(imagePath));

                          print("TEST");

                          await uploadTask.onComplete;
                          final url = await storageReference.getDownloadURL();

                          await Firestore.instance.collection('posts').add({
                            'date': date,
                            'itemCount': itemCount,
                            'latitude': locationData.latitude.toString(),
                            'longitude': locationData.longitude.toString(),
                            'url': url
                          });
                          Navigator.pop(context);
                        }
                      },
                      child: Icon(Icons.add_to_photos),
                    ))),
          ),
        ]));
  }
}
