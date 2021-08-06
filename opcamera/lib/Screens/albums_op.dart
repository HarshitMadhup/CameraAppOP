// import './image_view.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import './image_view.dart';

class AlbumsOp extends StatefulWidget {
  const AlbumsOp({key}) : super(key: key);

  @override
  _AlbumsOpState createState() => _AlbumsOpState();
}

class _AlbumsOpState extends State<AlbumsOp> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text("ALBUMS"),
          backgroundColor: Colors.pink[800],
        ),
        body: Center(
          child: Column(
            children: [
              GestureDetector(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => ImageView()),
                  );
                },
                child: Card(
                  elevation: 8.0,
                  color: Colors.amberAccent,
                  margin: EdgeInsets.all(10.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Image.asset(
                        'images/folder2.jpg',
                        width: 100,
                      ),
                      Text(
                        " Folder Name",
                        style: TextStyle(
                            fontWeight: FontWeight.w400, fontSize: 20),
                      ),
                    ],
                  ),
                ),
              )
            ],
          ),
        ));
  }
}
