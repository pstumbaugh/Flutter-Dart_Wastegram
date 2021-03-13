import '../imports.dart';
import 'package:intl/intl.dart';

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
            Text(
              'Wasteagram',
              style: Styles.headline1,
            ),
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
    return ListView(
      children: <Widget>[
        Padding(
          padding: const EdgeInsets.only(top: 20),
          child: Column(
            children: [
              Text(DateFormat.yMMMd().format(entry.date.toDate()),
                  style: Styles.headline2),
            ],
          ),
        ),
        Padding(
          padding: const EdgeInsets.only(top: 80),
          child: Column(
            children: [
              ImageWidget(imagePath: entry.url),
              //Image.network(entry.url),
              Padding(
                padding: const EdgeInsets.only(top: 30),
                child: Text('Items: ' + entry.itemCount.toString(),
                    style: Styles.headline4),
              ),
              Padding(
                padding: const EdgeInsets.only(top: 20),
                child: Container(
                    child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: <Widget>[
                    Text('Location: (' +
                        entry.latitude +
                        ', ' +
                        entry.longitude +
                        ')'),
                  ],
                )),
              ),
            ],
          ),
        )
      ],
    );
  }
}
