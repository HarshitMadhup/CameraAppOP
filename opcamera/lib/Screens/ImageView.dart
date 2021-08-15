import 'dart:io';

import 'package:flutter/material.dart';
import 'package:gallery_saver_safety/gallery_saver_safety.dart';
import 'package:path/path.dart';
import 'package:photofilters/photofilters.dart';
import 'package:image/image.dart' as imageLib;

class ImageView extends StatefulWidget {
  bool isTemp;
  final String? path;
  ImageView({this.path, required this.isTemp});

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
        appBar: AppBar(backgroundColor: Colors.black, actions: [
          widget.isTemp
              ? Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: GestureDetector(
                    onTap: () => Navigator.of(context).pop(),
                    child: Icon(
                      Icons.delete,
                      color: Colors.white,
                      size: 28.0,
                    ),
                  ),
                )
              : Container(),
          Padding(
            padding: const EdgeInsets.all(10.0),
            child: GestureDetector(
              onTap: () => _getImage(context),
              child: Icon(
                Icons.edit,
                color: Colors.white,
                size: 28.0,
              ),
            ),
          ),
        ]),
        backgroundColor: Colors.white,
        body: Center(
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
        floatingActionButton: FloatingActionButton(
          backgroundColor: Colors.black,
          child: Icon(Icons.save),
          onPressed: () async {
            imageFile == null
                ? GallerySaver.saveImage(widget.path!)
                    .then((success) => Navigator.pop(context))
                : GallerySaver.saveImage(imageFile!.path)
                    .then((success) => Navigator.pop(context));
          },
        ),
      ),
    );
  }
}
