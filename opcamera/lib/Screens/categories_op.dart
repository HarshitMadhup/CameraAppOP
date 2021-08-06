import 'package:flutter/material.dart';

class CategoriesOp extends StatefulWidget {
  const CategoriesOp({Key key}) : super(key: key);

  @override
  _CategoriesOpState createState() => _CategoriesOpState();
}

class _CategoriesOpState extends State<CategoriesOp> {

  createNewFolder(BuildContext context){
    TextEditingController myController = TextEditingController();

    return showDialog(context: context, builder: (context){
      return AlertDialog(
       title: Text("Please enter the name of the new folder"),
        content: TextField(
          controller: myController,
        ),
        actions: [
          MaterialButton(
            child: Text("Submit"),
            onPressed: (){
              Navigator.of(context).pop(myController.text.toString());
            },
          )
        ],
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Categories"),
        backgroundColor: Colors.pink[800],
      ),
      body: Center(
        child: Container(),
      ),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.add),
        onPressed: (){
          createNewFolder(context);
        },
      ),
    );
  }
}
