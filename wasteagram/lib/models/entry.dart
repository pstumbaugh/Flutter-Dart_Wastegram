import 'package:cloud_firestore/cloud_firestore.dart';

class Entry {
  Entry(DocumentSnapshot doc) {
    this.date = doc['date'];
    this.itemCount = doc['itemCount'];
    this.url = doc['url'];
    this.latitude = doc['latitude'];
    this.longitude = doc['longitude'];
  }

  Entry.fromMap({
    this.date,
    this.itemCount,
    this.url,
    this.latitude,
    this.longitude,
  });

  String date;
  String url;
  String latitude;
  String longitude;
  int itemCount;
}
