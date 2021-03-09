import 'dart:io';

import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:wasteagram/screens/new_post_screen.dart';
import '../models/entry.dart';
import 'package:image_picker/image_picker.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'detail_screen.dart';
import 'package:path/path.dart' as Path;

class ListScreen extends StatefulWidget {
  @override
  ListScreenState createState() => ListScreenState();
}

class ListScreenState extends State<ListScreen> {
  final picker = ImagePicker();
  File image;
  String imagePath;

  void initState() {
    super.initState();
  }

  // Allows user to grab image from image gallery
  Future getImage() async {
    print("INSIDE getImage()");

    // ignore: deprecated_member_use
    image = await ImagePicker.pickImage(source: ImageSource.gallery);
    print("TEST");
    StorageReference storageReference =
        FirebaseStorage.instance.ref().child(Path.basename(image.path));
    print("TEST2");
    StorageUploadTask uploadTask = storageReference.putFile(image);
    print("TEST3");
    await uploadTask.onComplete;
    print("TEST4");
    imagePath = await storageReference.getDownloadURL();
    setState(() {});

    print("TEST");
    print("EXITING getImage()");
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Column(children: [
          const Text('Wasteagram'),
        ]),
      ),

      // PostList() is a listview of all "posts" stored in firebase
      body: PostList(),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      floatingActionButton: Semantics(
        label: "New Post",
        hint: "Touch to create new post",
        child: FloatingActionButton(
          key: Key('postButton'),
          child: Icon(Icons.add),
          onPressed: () async {
            // wait for image to be selected before navigating
            await getImage();
            Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => NewPostScreen(imagePath: imagePath)));
          },
        ),
      ),
    );
  }
}

class PostList extends StatefulWidget {
  @override
  _PostListState createState() => _PostListState();
}

class _PostListState extends State<PostList> {
  @override
  Widget build(BuildContext context) {
    // Scrollable list view
    Widget _buildListItem(BuildContext context, Entry entry) {
      return Semantics(
        label: "Date: ${entry.date}",
        // generate a ListTile for each entry passed into this function
        child: ListTile(
            title: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(entry.date),
                  Text('Items: ' + entry.itemCount.toString()),
                ]),
            onTap: () {
              // Navigate to post details when tapped
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => DetailScreen(entry: entry)));
            }),
      );
    }

    return StreamBuilder(
        // Stream of data the StreamBuilder is listening to
        stream: Firestore.instance.collection('posts').snapshots(),
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
