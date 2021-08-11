import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:opcamera/Screens/ImageView.dart';
import 'package:path_provider/path_provider.dart';

class FavouritesOp extends StatefulWidget {
  const FavouritesOp();

  @override
  _FavouritesOpState createState() => _FavouritesOpState();
}

class _FavouritesOpState extends State<FavouritesOp> {
  List paths = [];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text("Favourites"),
          backgroundColor: Colors.black,
        ),
        body: Center(
            child: GridView.count(
          crossAxisCount: 5,
          children: paths
              .map((path) => InkWell(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (builder) => ImageView(
                          path: path,
                        ),
                      ),
                    );
                  },
                  child: Image.file(File(path))))
              .toList(),
        )),
        floatingActionButton: FloatingActionButton(
            backgroundColor: Colors.black,
            child: Icon(Icons.add),
            onPressed: () {
              captureAndSaveImage();
            }));
  }

  Future<File?> captureAndSaveImage() async {
    final pickedImage =
        await ImagePicker().getImage(source: ImageSource.gallery);
    setState(() {
      paths.add(pickedImage!.path);
    });
    if (pickedImage == null) return null;

    try {
      final directory = await getExternalStorageDirectory();
      if (directory != null)
        return File(pickedImage.path)
            .copy('${directory.path}/${DateTime.now()}.png');
    } catch (e) {
      return null;
    }
  }
}
