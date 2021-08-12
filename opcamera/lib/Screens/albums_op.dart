// @dart=2.9
import 'dart:io';
import 'dart:typed_data';

import 'package:flutter_file_manager/flutter_file_manager.dart';
import 'package:image_picker/image_picker.dart';
import 'package:opcamera/Screens/utils.dart';
import 'package:path_provider/path_provider.dart';
import 'package:path_provider_ex/path_provider_ex.dart';
import 'package:photo_manager/photo_manager.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class AlbumsOp extends StatefulWidget {
  const AlbumsOp({key}) : super(key: key);

  @override
  _AlbumsOpState createState() => _AlbumsOpState();
}

class _AlbumsOpState extends State<AlbumsOp> {
  List<AssetEntity> _mediaList = [];

  var paths;

  List<File> files;
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("ALBUMS"),
        backgroundColor: Colors.black,
      ),
      body: MediaGrid(),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          captureAndSaveImage();
          getFiles();
        },
      ),
    );
  }

  Future captureAndSaveImage() async {
    final pickedImage =
        await ImagePicker().getImage(source: ImageSource.gallery);
    setState(() {
      paths.add(pickedImage.path);
    });
    if (pickedImage == null) return null;

    try {
      final directory = await getExternalStorageDirectory();
      String path = await _createFolder();
      if (directory != null) {
        File(pickedImage.path).copy('${path}/${DateTime.now()}.png');
        getFiles();
      }
    } catch (e) {
      return null;
    }
  }

  Future<String> _createFolder(String album) async {
    var paths = "storage/emulated/0/$album";
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
    String path = await _createFolder();
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

class MediaGrid extends StatefulWidget {
  @override
  _MediaGridState createState() => _MediaGridState();
}

class _MediaGridState extends State<MediaGrid> {
  List<AssetEntity> _mediaList = [];

  var paths;

  List<File> files;
  @override
  void initState() {
    super.initState();
    _fetchNewMedia();
  }

  _fetchNewMedia() async {
    var result = await PhotoManager.requestPermission();
    if (result) {
      // success
//load the album list
      List<AssetPathEntity> albums =
          await PhotoManager.getAssetPathList(onlyAll: true);
      print(albums);
      List<AssetEntity> media = await albums[0].getAssetListPaged(0, 700);
      print(media);
      setState(() {
        _mediaList = media;
      });
    } else {
      // fail
      /// if result is fail, you can call `PhotoManager.openSetting();`  to open android/ios applicaton's setting to get permission
    }
  }

  @override
  Widget build(BuildContext context) {
    return PhotoManagerWidget();
  }
}

class Albums extends StatelessWidget {
  const Albums({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {},
      child: Container(
        height: 300,
        width: double.infinity,
        color: Colors.yellow,
        child: Text("Album"),
      ),
    );
  }
}
