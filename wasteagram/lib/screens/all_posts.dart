//This screen shows the list of items currently in the database

import '../imports.dart';
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
  var totalWaste = 0;

  void initState() {
    super.initState();
  }

//Building the list screen:
  @override
  Widget build(BuildContext context) {
    ProgressDialog progressDialog =
        ProgressDialog(context: context, barrierDismissible: false);
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: titleAndTotalWaste(),
      ),
      body: ListsOfPosts(), //list of posts from database
      //add a button for the user to add a new post:
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      floatingActionButton: Semantics(
        label: "New Post",
        hint: "Tap to create new post",
        child: FloatingActionButton(
          backgroundColor: Colors.blue[400],
          hoverColor: Colors.blue[800],
          splashColor: Colors.blue[900],
          key: Key('postButton'),
          child: Icon(Icons.add_photo_alternate),
          onPressed: () async {
            getPictureAndRoute(progressDialog);
          },
        ),
      ),
    );
  }

  //displays the app's title and the total waste in the database
  StreamBuilder titleAndTotalWaste() {
    return StreamBuilder(
        stream: Firestore.instance.collection('posts').snapshots(),
        builder: (context, snapshot) {
          if (!snapshot.hasData)
            return Text('Wastegram');
          else {
            for (int index = 0;
                index < snapshot.data.documents.length;
                index++) {
              totalWaste = getTotalWaste(
                  snapshot.data.documents[index]['itemCount'], totalWaste);
            }
            int wasteTotal =
                totalWaste; //Ensures that it doesn't double values when reloads
            totalWaste = 0;
            return Text('Wasteagram - $wasteTotal');
          }
        });
  }

  //adds up total waste
  int getTotalWaste(int quantity, int totalWaste) {
    return totalWaste = totalWaste + quantity;
  }

  //prompts to get a picture from the user from the phone's gallery
  //It will save it to the firebase storage, then return a download URL
  //It then saves that download URL as a string to the global variable "imagePath"
  Future getImage() async {
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

//pops up a box with the progress indicator (using while waiting for async functions to complete)
//NOTE - progressDialog.dismiss(); must be called after to remove the progress indicator from screen
  void showProgressIndicator(ProgressDialog progressDialog) {
    return progressDialog.showMaterial(
      backgroundColor: Colors.grey[300],
      message: "Loading picture",
      messageStyle: TextStyle(
          color: Colors.blue[800], fontSize: 17, fontWeight: FontWeight.bold),
      title: "Wasteagram",
      titleStyle: TextStyle(
        color: Colors.blue[800],
        fontSize: 22,
      ),
      centerTitle: true,
      layout: MaterialProgressDialogLayout
          .columnReveredWithCircularProgressIndicator,
    );
  }

  //gets a new pic from user, then routes to the new post screen
  Future<void> getPictureAndRoute(ProgressDialog progressDialog) async {
    showProgressIndicator(
        progressDialog); //show progress indicator (on list page)
    await getImage(); // wait for image to be selected before navigating
    progressDialog.dismiss(); //remove progress indicator
    Navigator.push(
        //go to the new post screen with the image's url
        context,
        MaterialPageRoute(
            builder: (context) => NewPostScreen(imagePath: imagePath)));
  }
}

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
