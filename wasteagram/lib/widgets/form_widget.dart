import 'package:flutter/semantics.dart';

import '../imports.dart';
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
          Padding(
            padding: const EdgeInsets.only(bottom: 30),
            child: TextFormField(
              textAlign: TextAlign.center,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(hintText: 'Items Wasted'),
              style: Styles.headline2,
              validator: (value) {
                if (!isNumAndPos(value)) {
                  return 'Please enter a positive number';
                }
                return null;
              },
              onSaved: (value) {
                itemCount = int.parse(value);
              },
            ),
          ),
          Container(
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(15.0),
                  border: Border.all(color: Colors.grey, width: 4)),
              foregroundDecoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(15.0),
                  border: Border.all(color: Colors.blueGrey, width: 7)),
              width: 100,
              height: 100,
              child: Semantics(
                label: "Submit",
                hint: "Submit",
                child: RaisedButton(
                  key: Key('submitButton'),
                  onPressed: () async {
                    if (formKey.currentState.validate()) {
                      formKey.currentState.save();
                      // Format Date
                      //OLD-> Timestamp date = DateFormat.yMd().format(DateTime.now());
                      var date = DateTime.now();

                      // Get location data (stores in longitude and latitude)
                      await retrieveLocation();

                      //StorageReference storageReference = FirebaseStorage.instance.ref().child(DateTime.now().toString());
                      //StorageUploadTask uploadTask = storageReference.putFile(File(imagePath));

                      //await uploadTask.onComplete;
                      //final url = imagePath;

                      await Firestore.instance.collection('posts').add({
                        'date': date,
                        'itemCount': itemCount,
                        'latitude': locationData.latitude.toString(),
                        'longitude': locationData.longitude.toString(),
                        'url': imagePath
                      });
                      Navigator.pop(context);
                    }
                  },
                  child: Icon(
                    Icons.cloud_upload_outlined,
                    size: 50,
                  ),
                ),
              )),
        ]));
  }

  bool isNumAndPos(String string) {
    // Null or empty string is not a number
    if (string == null || string.isEmpty) {
      return false;
    }
    //parse a string to a number (will return null if not number)
    final number = num.tryParse(string);
    if (number == null) {
      return false;
    }
    //if value is a number, check to make sure it's greater than 0
    if (number <= 0) {
      return false;
    }
    return true;
  }
}
