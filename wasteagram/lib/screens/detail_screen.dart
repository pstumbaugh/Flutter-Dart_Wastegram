import 'package:flutter/material.dart';
import 'package:wasteagram/models/entry.dart';

class DetailScreen extends StatefulWidget {
  final Entry entry;

  DetailScreen({this.entry});
  @override
  _DetailScreenState createState() => _DetailScreenState(entry: entry);
}

class _DetailScreenState extends State<DetailScreen> {
  Entry entry;
  _DetailScreenState({this.entry});
  @override
  Widget build(BuildContext context) {
    print(entry.url);
    return Scaffold(
        appBar: AppBar(
          centerTitle: true,
          title: Column(children: [
            const Text('Wasteagram'),
            //Text('WasteCount: ' + wasteCount.toString()),
          ]),
        ),
        body: DisplayColumn(entry: entry));
  }
}

class DisplayColumn extends StatelessWidget {
  final Entry entry;
  DisplayColumn({this.entry});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(entry.date),
        Image.network(entry.url),
        Text('Items: ' + entry.itemCount.toString()),
        Expanded(
            child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: <Widget>[
            Text('Latitude: ' + entry.latitude),
            Text('Longitude: ' + entry.longitude),
          ],
        ))
      ],
    );
  }
}
