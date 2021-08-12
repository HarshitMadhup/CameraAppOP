import 'dart:io';

import 'package:flutter/material.dart';
import 'package:gallery_saver_safety/gallery_saver_safety.dart';
import 'package:path/path.dart';
import 'package:photofilters/photofilters.dart';
import 'package:image/image.dart' as imageLib;

class ImageView extends StatefulWidget {
  final String? path;
  ImageView({this.path});

  @override
  _ImageViewState createState() => _ImageViewState();
}

class _ImageViewState extends State<ImageView> {
  String? fileName;
  List<Filter> filters = presetFiltersList;
  File? imageFile;

  _getImage(context) async {
    imageFile = File(widget.path.toString());
    fileName = basename(imageFile!.path);
    var image = imageLib.decodeImage(await imageFile!.readAsBytes());
    image = imageLib.copyResize(image!, width: 600);
    Map imagefile = await Navigator.push(
      context,
      new MaterialPageRoute(
        builder: (context) => new PhotoFilterSelector(
          appBarColor: Colors.black,
          title: Text("Photo Filter"),
          image: image!,
          filters: presetFiltersList,
          filename: fileName!,
          loader: Center(child: CircularProgressIndicator()),
          fit: BoxFit.contain,
        ),
      ),
    );

    if (imagefile != null && imagefile.containsKey('image_filtered')) {
      setState(() {
        imageFile = imagefile['image_filtered'];
      });
      print(imageFile!.path);
    }
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: Colors.black,
        body: Column(
          children: [
            Container(
              padding:
                  const EdgeInsets.symmetric(vertical: 10.0, horizontal: 10.0),
              color: Colors.black,
              child: Row(
                mainAxisSize: MainAxisSize.max,
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  GestureDetector(
                    onTap: () => Navigator.pop(context),
                    child: Icon(
                      Icons.arrow_back,
                      color: Colors.white,
                      size: 28.0,
                    ),
                  ),
                  Container(
                    width: 250.0,
                    child: Text(
                      "${widget.path}",
                      style: TextStyle(fontSize: 12.0, color: Colors.white),
                      textAlign: TextAlign.left,
                    ),
                  ),
                  GestureDetector(
                    onTap: () => _getImage(context),
                    child: Icon(
                      Icons.edit,
                      color: Colors.white,
                      size: 28.0,
                    ),
                  ),
                ],
              ),
            ),
            Expanded(
              child: Container(
                child: imageFile == null
                    ? Image.file(
                        File(
                          widget.path.toString(),
                        ),
                        fit: BoxFit.contain,
                      )
                    : Image.file(
                        new File(imageFile!.path),
                        fit: BoxFit.contain,
                      ),
              ),
            ),
          ],
        ),
        floatingActionButton: FloatingActionButton(
          backgroundColor: Colors.black,
          child: Icon(Icons.save),
          onPressed: () async {
            GallerySaver.saveImage(imageFile!.path)
                .then((success) => print("success"));
          },
        ),
      ),
    );
  }