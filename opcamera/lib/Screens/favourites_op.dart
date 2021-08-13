import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_file_manager/flutter_file_manager.dart';
import 'package:image_picker/image_picker.dart';
import 'package:opcamera/Screens/ImageView.dart';
import 'package:path_provider/path_provider.dart';
import 'package:path_provider_ex/path_provider_ex.dart';

class FavouritesOp extends StatefulWidget {
  const FavouritesOp();

  @override
  _FavouritesOpState createState() => _FavouritesOpState();
}

class _FavouritesOpState extends State<FavouritesOp> {
  List paths = [];
  List files = [];

  @override
  void initState() {
    getFiles(); //call getFiles() function on initial state.
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        actions: [
          IconButton(
              onPressed: () {
                setState(() {
                  getFiles();
                });
              },
              icon: Icon(Icons.refresh))
        ],
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
                      return ImageView(
                          path: files[index].path.toString(), isTemp: false);
                      //open viewPDF page on click
                    }));
                  },
                ));
              },
            ),
      floatingActionButton: FloatingActionButton(
          backgroundColor: Colors.black,
          child: Icon(Icons.add),
          onPressed: () async {
            captureAndSaveImage();
            setState(() {
              getFiles();
            });
          }),
    );
  }

  captureAndSaveImage() async {
    final PickedFile? pickedImage =
        await ImagePicker().getImage(source: ImageSource.gallery);

    if (pickedImage == null) return null;

    try {
      final directory = await getExternalStorageDirectory();
      String path = await _createFolder();
      if (directory != null)
        return File(pickedImage.path).copy('${path}/${DateTime.now()}.png');
    } catch (e) {
      return null;
    }
  }

  Future<String> _createFolder() async {
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

  void getFiles() async {
    //asyn function to get list of files
    // final Permission _permissionHandler = Permission();
    // var result =
    //     await _permissionHandler.requestPermissions([PermissionGroup.contacts]);
    List<StorageInfo> storageInfo = await PathProviderEx.getStorageInfo();
    var root = storageInfo[0]
        .rootDir; //storageInfo[1] for SD card, geting the root directory
    var fm = FileManager(root: Directory("storage/emulated/0/Favourites")); //

    setState(() async {
      files = await fm.filesTree(
          excludedPaths: ["storage/emulated/0/Favourites"],
          extensions: ["png"]);
      print("Files" + files.toString());
    }); //update the UI
  }
}
