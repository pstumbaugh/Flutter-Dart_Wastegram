//This screen shows the list of items currently in the database

import 'dart:io';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:location/location.dart';
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
  String imagePath;
  File image;
  LocationData locationData;

  void initState() {
    super.initState();
  }

  //prompts to get a picture from the user from the phone's gallery
  //It will save it to the firebase storage, then return a download URL
  //It then saves that download URL as a string to the global variable "imagePath"
  void getImage() async {
    image = await ImagePicker.pickImage(source: ImageSource.gallery);
    StorageReference storageReference =
        FirebaseStorage.instance.ref().child(Path.basename(image.path));
    StorageUploadTask uploadTask = storageReference.putFile(image);
    await uploadTask.onComplete;
    imagePath = await storageReference.getDownloadURL();
  }

/* OLD METHOD OF GETTING PICTURE:
  void getImage() async {
    final pickedFile = await picker.getImage(source: ImageSource.gallery);
    imagePath = pickedFile.path;
    setState(() {});
  }
*/

//Building the list screen:
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Column(children: [
          const Text('Wasteagram'),
        ]),
      ),
      body: PostList(), //list of posts from database
      //add a button for the user to add a new post:
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      floatingActionButton: Semantics(
        label: "New Post",
        hint: "Tap to create new post",
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
