// @dart=2.9
import 'package:flutter/material.dart';
import 'package:opcamera/Screens/image_category.dart';
import 'package:opcamera/Screens/video_category.dart';
import 'package:photo_manager/photo_manager.dart';

class CategoriesOp extends StatefulWidget {
  const CategoriesOp();

  @override
  _CategoriesOpState createState() => _CategoriesOpState();
}

class _CategoriesOpState extends State<CategoriesOp> {
  createNewFolder(BuildContext context) {
    TextEditingController myController = TextEditingController();

    return showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: Text("Please enter the name of the new folder"),
            content: TextField(
              controller: myController,
            ),
            actions: [
              MaterialButton(
                child: Text("Submit"),
                onPressed: () {
                  Navigator.of(context).pop(myController.text.toString());
                },
              )
            ],
          );
        });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Categories"),
        backgroundColor: Colors.black,
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          GestureDetector(
            onTap: () async {
              final permitted = await PhotoManager.requestPermission();
              if (!permitted) return;
              Navigator.of(context).push(
                MaterialPageRoute(builder: (_) => ImageGallery()),
              );
            },
            child: Container(
              margin: EdgeInsets.fromLTRB(30, 10, 30, 10),
              height: MediaQuery.of(context).size.height / 5,
              color: Colors.blue[200],
              child: Center(
                child: Text(
                  "Images",
                  style: TextStyle(color: Colors.white, fontSize: 30),
                ),
              ),
            ),
          ),
          GestureDetector(
            onTap: () async {
              final permitted = await PhotoManager.requestPermission();
              if (!permitted) return;
              Navigator.of(context).push(
                MaterialPageRoute(builder: (_) => VideoGallery()),
              );
            },
            child: Container(
              margin: EdgeInsets.fromLTRB(30, 10, 30, 10),
              height: MediaQuery.of(context).size.height / 5,
              color: Colors.blue[200],
              child: Center(
                child: Text(
                  "Videos",
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 30,
                  ),
                ),
              ),
            ),
          )
        ],
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.black,
        child: Icon(Icons.add),
        onPressed: () {
          createNewFolder(context);
        },
      ),
    );
  }
}
