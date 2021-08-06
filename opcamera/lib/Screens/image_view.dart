import 'package:flutter/material.dart';

class ImageView extends StatefulWidget {
  const ImageView({Key key}) : super(key: key);

  @override
  _ImageViewState createState() => _ImageViewState();
}

class _ImageViewState extends State<ImageView> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Images"),),
      body: GridView.extent(
        maxCrossAxisExtent: 150.0,
        mainAxisSpacing: 5.0,
        crossAxisSpacing: 5.0,
        padding: const EdgeInsets.all(5.0),
        children: _buildGridTiles(12),
        //crossAxisCount: 3,
        // children: List.generate(9, (index) {
        //   return Center(
        //     child: Card(
        //       elevation: 8.0,
        //       margin: EdgeInsets.all(7.0),
        //       child: Image.network(
        //       "https://png.pngtree.com/png-clipart/20201105/ourlarge/pngtree-orange-red-fire-ball-flame-clip-art-png-image_2388411.jpg",
        //       ),
        //     ),
        //   );
        // }),
      ),
    );
  }
}
List<Widget> _buildGridTiles(numberOfTiles) {
  List<Container> containers = new List<Container>.generate(numberOfTiles,
          (int index) {
        //index = 0, 1, 2,...
        final imageName = index < 9 ?
        'images/image0${index + 1}.jpg' : 'images/image${index + 1}.jpg';
        return new Container(
          child: new Image.asset(
              imageName,
              fit: BoxFit.fill
          ),
        );
      });
  return containers;
}