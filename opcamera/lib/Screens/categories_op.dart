import 'package:flutter/material.dart';

class CategoriesOp extends StatefulWidget {
  const CategoriesOp();

  @override
  _CategoriesOpState createState() => _CategoriesOpState();
}

class _CategoriesOpState extends State<CategoriesOp> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Categories"),
        backgroundColor: Colors.black,
      ),
      body: Center(
        child: Container(),
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.black,
        child: Icon(Icons.add),
        onPressed: () {},
      ),
    );
  }
}
