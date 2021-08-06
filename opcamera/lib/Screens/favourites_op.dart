import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class FavouritesOp extends StatefulWidget {
  const FavouritesOp({Key key}) : super(key: key);

  @override
  _FavouritesOpState createState() => _FavouritesOpState();
}

class _FavouritesOpState extends State<FavouritesOp> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Favourites"),
        backgroundColor: Colors.pink[800],
      ),
      body: Center(
        child: Container(),
      ),
    );
  }
}
