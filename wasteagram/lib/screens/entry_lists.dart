import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class EntryLists extends StatefulWidget {
  @override
  _EntryListsState createState() => _EntryListsState();
}

class _EntryListsState extends State<EntryLists> {
  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
        stream: Firestore.instance.collection('wastegram').snapshots(),
        builder: (context, snapshot) {
          if (snapshot.hasData &&
              snapshot.data.documents != null &&
              snapshot.data.documents.length > 0) {
            var totalWaste = 0;
            for (var i = 0; i < snapshot.data.documents.length; i++) {
              totalWaste += snapshot.data.documents[i]['total_waste'];
            }
            return Scaffold(
              appBar: AppBar(title: Text('Wastegram - $totalWaste')),
              body: ListView.builder(
                  itemCount: snapshot.data.documents.length,
                  itemBuilder: (context, index) {
                    var post = snapshot.data.documents[index];
                    return ListTile(
                      title: Text(post['date']),
                      subtitle: Text(post['total_waste'].toString()),
                      onTap: () {
                        Navigator.of(context)
                            .pushNamed('wasteDetails', arguments: {
                          'date': post['date'],
                          'image': post['image_url'],
                          'items': post['total_waste'],
                          'longitude': post['longitude'],
                          'latitude': post['latitude']
                        });
                      },
                    );
                  }),
              floatingActionButton: NewEntryButton(),
              floatingActionButtonLocation:
                  FloatingActionButtonLocation.centerFloat,
            );
          } else {
            return Scaffold(
              appBar: AppBar(
                title: Text('Wastegram'),
              ),
              body: Center(
                child: CircularProgressIndicator(),
              ),
              floatingActionButton: NewEntryButton(),
              floatingActionButtonLocation:
                  FloatingActionButtonLocation.centerFloat,
            );
          }
        });
  }
}

class NewEntryButton extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return FloatingActionButton(
        child: Icon(Icons.add),
        onPressed: () {
          Navigator.of(context).pushNamed('pictures');
        });
  }
}
