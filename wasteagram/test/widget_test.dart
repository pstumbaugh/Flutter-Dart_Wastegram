import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:wasteagram/imports.dart';
import 'package:wasteagram/widgets/form_widget.dart' as formWidget;
import 'package:intl/intl.dart';

void main() {
  test('Values Added by Direct Insertion', () {
    DocumentSnapshot doc;
    Timestamp day = DateTime.now();
    String url = "fakeImage.com";
    String lat = '140.3';
    String long = '-42';
    int itemCount;

    final post = Entry(doc);
    post.date = day;
    post.itemCount = url as int;
    post.url = url;
    post.latitude = lat;
    post.longitude = long;

    expect(post.date, day);
    expect(post.itemCount, itemCount);
    expect(post.url, url);
    expect(post.latitude, lat);
    expect(post.longitude, long);
  });
}
