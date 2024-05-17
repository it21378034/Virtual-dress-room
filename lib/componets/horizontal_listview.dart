import 'package:flutter/material.dart';

class HorizontalList extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      height: 110.0,
      child: ListView(
        scrollDirection: Axis.horizontal,
        children: <Widget>[
          Category(
            imageLocation: 'images/cats/shirt.png',
            imageCaption: 'shirt',
          ),
          Category(
            imageLocation: 'images/cats/dress.png',
            imageCaption: 'dress',
          ),
          Category(
            imageLocation: 'images/cats/formal.png',
            imageCaption: 'formal',
          ),
          Category(
            imageLocation: 'images/cats/jeans.png',
            imageCaption: 'pants',
          ),
          Category(
            imageLocation: 'images/cats/informal.png',
            imageCaption: 'Informal',
          ),
        ],
      ),
    );
  }
}

class Category extends StatelessWidget {
  final String imageLocation;
  final String imageCaption;

  Category({required this.imageLocation, required this.imageCaption});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(2.0),
      child: InkWell(
        onTap: () {},
        child: Container(
          width: 100.0,
          child: ListTile(
            title: Image.asset(
              imageLocation,
              width: 100.0,
              height: 80.0,
            ),
            subtitle: Container(
              alignment: Alignment.topCenter,
              child: Text(
                imageCaption,
                style: new TextStyle(fontSize: 12.0),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

void main() {
  runApp(MaterialApp(
    debugShowCheckedModeBanner: false,
    home: Scaffold(
      appBar: AppBar(title: Text('Fashion App')),
      body: HorizontalList(),
    ),
  ));
}
