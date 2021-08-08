import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class FavouritesOp extends StatefulWidget {
  const FavouritesOp();

  @override
  _FavouritesOpState createState() => _FavouritesOpState();
}

class _FavouritesOpState extends State<FavouritesOp> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Favourites"),
        backgroundColor: Colors.black,
      ),
      body: Center(
        child: Container(),
      ),
    );
  }
}
