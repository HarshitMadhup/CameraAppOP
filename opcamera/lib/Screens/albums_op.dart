import 'dart:typed_data';

import 'package:opcamera/Screens/utils.dart';
import 'package:photo_manager/photo_manager.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class AlbumsOp extends StatefulWidget {
  const AlbumsOp({key}) : super(key: key);

  @override
  _AlbumsOpState createState() => _AlbumsOpState();
}

class _AlbumsOpState extends State<AlbumsOp> {
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
    );
  }
}

class MediaGrid extends StatefulWidget {
  @override
  _MediaGridState createState() => _MediaGridState();
}

class _MediaGridState extends State<MediaGrid> {
  List<AssetEntity> _mediaList = [];
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
