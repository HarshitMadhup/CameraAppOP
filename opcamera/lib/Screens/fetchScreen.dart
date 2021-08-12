// @dart=2.9
import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_file_manager/flutter_file_manager.dart';
import 'package:image_picker/image_picker.dart';
import 'package:opcamera/Screens/ImageView.dart';
import 'package:path_provider/path_provider.dart';
import 'package:path_provider_ex/path_provider_ex.dart';

class FetchScreen extends StatefulWidget {
  String path;
  FetchScreen({this.path});

  @override
  _FavouritesOpState createState() => _FavouritesOpState();
}

class _FavouritesOpState extends State<FetchScreen> {
  List paths = [];
  List files = [];

  @override
  void initState() {
    getFiles(widget.path); //call getFiles() function on initial state.
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Favourites"),
        backgroundColor: Colors.black,
      ),
      body: files == null
          ? Text("Searching Files")
          : ListView.builder(
              //if file/folder list is grabbed, then show here
              itemCount: files.length,
              itemBuilder: (context, index) {
                return Card(
                    child: ListTile(
                  title: Text(files[index].path.split('/').last),
                  leading: Icon(Icons.image),
                  onTap: () {
                    Navigator.push(context,
                        MaterialPageRoute(builder: (context) {
                      return ImageView(path: files[index].path.toString());
                      //open viewPDF page on click
                    }));
                  },
                ));
              },
            ),
    );
  }

  void getFiles(String path) async {
    //asyn function to get list of files
    // final Permission _permissionHandler = Permission();
    // var result =
    //     await _permissionHandler.requestPermissions([PermissionGroup.contacts]);
    List<StorageInfo> storageInfo = await PathProviderEx.getStorageInfo();
    var root = storageInfo[0]
        .rootDir; //storageInfo[1] for SD card, geting the root directory
    var fm = FileManager(root: Directory(path)); //

    setState(() async {
      files = await fm.filesTree(
          // excludedPaths: ["storage/emulated/0/Favourites"],
          extensions: ["png"] //optional, to filter files, list only pdf files
          );
      print("Files" + files.toString());
    }); //update the UI
  }
}
