import '../imports.dart';

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
    //print("URL of picture in post: " + entry.url);
    return Scaffold(
        appBar: AppBar(
          centerTitle: true,
          title: Column(children: [
            const Text('Wasteagram'),
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
        Padding(
          padding: const EdgeInsets.only(top: 20),
          child: Text(
            entry.date,
          ),
        ),
        ImageWidget(imagePath: entry.url),
        //Image.network(entry.url),
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
