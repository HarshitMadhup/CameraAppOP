// import './image_view.dart';
import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:opcamera/Screens/utils.dart';
import 'package:path_provider/path_provider.dart';

import './image_view.dart';

class AlbumsOp extends StatefulWidget {
  const AlbumsOp({key}) : super(key: key);

  @override
  _AlbumsOpState createState() => _AlbumsOpState();
}

class _AlbumsOpState extends State<AlbumsOp> {
  String? folderName;
  AppUtil utils = new AppUtil();
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
                      style:
                          TextStyle(fontWeight: FontWeight.w400, fontSize: 20),
                    ),
                  ],
                ),
              ),
            )
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          createNewFolder(context);
          utils.createFolderInAppDocDir(folderName!);
        },
      ),
    );
  }

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
                  setState(() {
                    folderName = myController.text;
                  });
                  Navigator.of(context).pop();
                },
              )
            ],
          );
        });
  }
}

class AppUtil {
  Future<String> createFolderInAppDocDir(String folderName) async {
    //Get this App Document Directory
    final Directory _appDocDir = await getApplicationDocumentsDirectory();
    //App Document Directory + folder name
    final Directory _appDocDirFolder =
        Directory('${_appDocDir.path}/$folderName/');

    if (await _appDocDirFolder.exists()) {
      //if folder already exists return path
      return _appDocDirFolder.path;
    } else {
      //if folder not exists create folder and then return its path
      final Directory _appDocDirNewFolder =
          await _appDocDirFolder.create(recursive: true);
      return _appDocDirNewFolder.path;
    }
  }
}
