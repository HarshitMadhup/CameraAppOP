// @dart=2.9
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_file_manager/flutter_file_manager.dart';
import 'package:opcamera/Screens/ImageView.dart';

import 'package:path_provider_ex/path_provider_ex.dart';
import 'package:permission_handler/permission_handler.dart';
//import package files

//apply this class on home: attribute at MaterialApp()
class MyPDFList extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _MyPDFList(); //create state
  }
}

class _MyPDFList extends State<MyPDFList> {
  var files;

  void getFiles() async {
    //asyn function to get list of files
    // final Permission _permissionHandler = Permission();
    // var result =
    //     await _permissionHandler.requestPermissions([PermissionGroup.contacts]);
    List<StorageInfo> storageInfo = await PathProviderEx.getStorageInfo();
    var root = storageInfo[0]
        .rootDir; //storageInfo[1] for SD card, geting the root directory
    var fm = FileManager(root: Directory(root)); //
    files = await fm.filesTree(
        excludedPaths: ["/storage/emulated/0/Android"],
        extensions: ["png"] //optional, to filter files, list only pdf files
        );
    setState(() {}); //update the UI
  }

  @override
  void initState() {
    getFiles(); //call getFiles() function on initial state.
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
            title: Text("PDF File list from SD Card"),
            backgroundColor: Colors.redAccent),
        body: files == null
            ? Text("Searching Files")
            : ListView.builder(
                //if file/folder list is grabbed, then show here
                itemCount: files?.length ?? 0,
                itemBuilder: (context, index) {
                  return Card(
                      child: ListTile(
                    title: Text(files[index].path.split('/').last),
                    leading: Icon(Icons.picture_as_pdf),
                    trailing: Icon(
                      Icons.arrow_forward,
                      color: Colors.redAccent,
                    ),
                    onTap: () {
                      Navigator.push(context,
                          MaterialPageRoute(builder: (context) {
                        return ImageView(path: files[index].path.toString());
                        //open viewPDF page on click
                      }));
                    },
                  ));
                },
              ));
  }

  _createFolder() async {
    final folderName = "Favourites";
    var paths = "storage/emulated/0/$folderName";
    final path = Directory(paths);
    if ((await path.exists())) {
      // TODO:
      return paths;
    } else {
      // TODO:
      print("not exist");
      path.create();
      return paths;
    }
  }
}
