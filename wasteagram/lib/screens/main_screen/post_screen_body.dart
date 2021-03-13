import 'package:intl/intl.dart';
import 'package:wasteagram/imports.dart';

//POST LIST SCREEN body:
class ListsOfPosts extends StatefulWidget {
  @override
  _ListsOfPostsState createState() => _ListsOfPostsState();
}

class _ListsOfPostsState extends State<ListsOfPosts> {
  @override
  Widget build(BuildContext context) {
    // Scrollable list view
    Widget _buildListItem(BuildContext context, Entry entry) {
      return Semantics(
        label: "Date: ${entry.date}",
        // generate a ListTile for each entry passed into this function
        child: Column(
          children: [
            ListTile(
                title: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(DateFormat.yMMMd().format(entry.date.toDate())),
                      Text('Items: ' + entry.itemCount.toString()),
                    ]),
                onTap: () {
                  // Navigate to post details when tapped
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => DetailScreen(entry: entry)));
                }),
          ],
        ),
      );
    }

    return StreamBuilder(
        // Stream of data the StreamBuilder is listening to
        //Sort based on date added
        stream: Firestore.instance
            .collection('posts')
            .orderBy('date', descending: true)
            .snapshots(),
        // builder invoked whenever new data is acquired
        // snapshot represents the potential value of a Future
        builder: (context, snapshot) {
          if (snapshot.hasData && !snapshot.data.documents.isEmpty) {
            // If data, display in a listview
            return ListView.builder(
                itemExtent: 80.0,
                // itemcount is the number of "documents" in firebase
                itemCount: snapshot.data.documents.length,
                // generate tiles for each item in database via itembuilder
                // + buildList funct
                itemBuilder: (context, index) {
                  // use entry.dart class for data retrieval
                  Entry entry = Entry(snapshot.data.documents[index]);
                  // send context and entry obj to buildListItem funct
                  return _buildListItem(context, entry);
                });
          } else {
            // CircularProgressIndicator when no data in online storage
            return Center(child: CircularProgressIndicator());
          }
        });
  }
}
