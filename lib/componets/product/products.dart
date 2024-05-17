import 'package:flutter/material.dart';
import 'package:virtual_dress_room/componets/product/product_details.dart';

class Products extends StatefulWidget {
  @override
  _ProductsState createState() => _ProductsState();
}

class _ProductsState extends State<Products> {
  var productList = [
    {
      "name": "Blazer",
      "picture": "images/products/blazer1.jpeg",
      "old_price": "120",
      "price": "85",
    },
    {
      "name": "Red dress",
      "picture": "images/products/dress1.jpeg",
      "old_price": "100",
      "price": "50",
    },
    {
      "name": "Red dress",
      "picture": "images/products/dress2.jpeg",
      "old_price": "100",
      "price": "50",
    },
    {
      "name": "Red dress",
      "picture": "images/products/skt1.jpeg",
      "old_price": "100",
      "price": "50",
    },
    {
      "name": "Red dress",
      "picture": "images/products/skt2.jpeg",
      "old_price": "100",
      "price": "50",
    },
  ];

  @override
  Widget build(BuildContext context) {
    return GridView.builder(
      itemCount: productList.length,
      gridDelegate:
          SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 2),
      itemBuilder: (BuildContext context, int index) {
        return Padding(
          padding: const EdgeInsets.all(4.0),
          child: SingleProd(
            prodName: productList[index]['name']!,
            prodPicture: productList[index]['picture']!,
            prodOldPrice: productList[index]['old_price']!,
            prodPrice: productList[index]['price']!,
          ),
        );
      },
    );
  }
}

class SingleProd extends StatelessWidget {
  final String prodName;
  final String prodPicture;
  final String prodOldPrice;
  final String prodPrice;

  SingleProd({
    required this.prodName,
    required this.prodPicture,
    required this.prodOldPrice,
    required this.prodPrice,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Material(
        child: InkWell(
          onTap: () => Navigator.of(context).push(MaterialPageRoute(
            builder: (context) => ProductDetails(
              productDetailName: prodName,
              productDetailNewPrice: double.parse(prodPrice),
              productDetailOldPrice: double.parse(prodOldPrice),
              productDetailPicture: prodPicture,
            ),
          )),
          child: GridTile(
            footer: Container(
              color: Colors.white,
              child: new Row(
                children: <Widget>[
                  Expanded(
                    child: Text(
                      prodName,
                      style: TextStyle(
                          fontWeight: FontWeight.bold, fontSize: 16.0),
                    ),
                  ),
                  new Text(
                    "\$${prodPrice}",
                    style: TextStyle(
                        color: Colors.red, fontWeight: FontWeight.bold),
                  )
                ],
              ),
            ),
            child: Image.asset(
              prodPicture,
              fit: BoxFit.cover,
            ),
          ),
        ),
      ),
    );
  }
}
