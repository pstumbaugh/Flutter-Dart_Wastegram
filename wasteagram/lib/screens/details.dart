import 'package:flutter/material.dart';

class WasteDetails extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final Map posts = ModalRoute.of(context).settings.arguments;
    //print('${posts['image']}');

    return Scaffold(
      appBar: AppBar(title: Text('Wastegram')),
      body: Container(
          child: Column(children: [
        Text('${posts['date']}'),
        Image(image: NetworkImage('${posts['image']}')),
        Text('Items: ${posts['items']}'),
        Text('(${posts['longitude']}, ${posts['latitude']})')
      ])),
    );
  }
}
