// ignore_for_file: unnecessary_new

import 'package:flutter/material.dart';

import '../pages/home.dart';
import '../pages/virtual_try_on.dart';

class ProductDetails extends StatefulWidget {
  final String productDetailName;
  final double productDetailNewPrice;
  final double productDetailOldPrice;
  final String productDetailPicture;

  ProductDetails({
    required this.productDetailName,
    required this.productDetailNewPrice,
    required this.productDetailOldPrice,
    required this.productDetailPicture,
  });

  @override
  _ProductDetailsState createState() => _ProductDetailsState();
}

class _ProductDetailsState extends State<ProductDetails> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0.1,
        backgroundColor: Colors.blue,
        title: InkWell(
            onTap: () {
              Navigator.push(context,
                  MaterialPageRoute(builder: (context) => new HomePage()));
            },
            child: Text('Fashion App')),
        actions: <Widget>[
          IconButton(
            icon: Icon(
              Icons.search,
              color: Colors.white,
            ),
            onPressed: () {
              // Handle search action
            },
          ),
        ],
      ),
      body: ListView(
        children: <Widget>[
          Container(
            height: 200.0,
            child: GridTile(
              child: Container(
                color: Colors.white,
                child: Image.asset(widget.productDetailPicture),
              ),
              footer: Container(
                color: Colors.white70,
                child: ListTile(
                  leading: Text(
                    widget.productDetailName,
                    style:
                        TextStyle(fontWeight: FontWeight.bold, fontSize: 16.0),
                  ),
                  title: Row(
                    children: <Widget>[
                      Expanded(
                        child: Text(
                          '\$${widget.productDetailOldPrice}',
                          style: TextStyle(
                              color: Colors.grey,
                              decoration: TextDecoration.lineThrough),
                        ),
                      ),
                      Expanded(
                        child: Text(
                          '\$${widget.productDetailNewPrice}',
                          style: TextStyle(
                              fontWeight: FontWeight.bold, color: Colors.red),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
          // Rest of the code...

          //     ============== the first buttons =========

          Row(
            children: <Widget>[
//  the side button
              Expanded(
                child: MaterialButton(
                  onPressed: () {
                    ///this line
                    showDialog(
                        context: context,
                        builder: (context) {
                          return new AlertDialog(
                            title: new Text("size"),
                            content: new Text("choose the size"),
                            actions: <Widget>[
                              new MaterialButton(
                                onPressed: () {
                                  Navigator.of(context).pop(context);
                                },
                                child: new Text("close"),
                              )
                            ],
                          );
                        });
                  },
                  color: Colors.white,
                  textColor: Colors.grey,
                  elevation: 0.2,
                  child: Row(
                    children: <Widget>[
                      const Expanded(child: Text("Size")),
                      Expanded(child: new Icon(Icons.arrow_drop_down)),
                    ],
                  ),
                ),
              ),

              //  the color button
              Expanded(
                child: MaterialButton(
                  onPressed: () {
                    ///this line
                    showDialog(
                        context: context,
                        builder: (context) {
                          return new AlertDialog(
                            title: new Text("color"),
                            content: new Text("choose a color"),
                            actions: <Widget>[
                              new MaterialButton(
                                onPressed: () {
                                  Navigator.of(context).pop(context);
                                },
                                child: new Text("close"),
                              )
                            ],
                          );
                        });
                  },
                  color: Colors.white,
                  textColor: Colors.grey,
                  elevation: 0.2,
                  child: Row(
                    children: <Widget>[
                      const Expanded(child: Text("Color")),
                      Expanded(child: new Icon(Icons.arrow_drop_down)),
                    ],
                  ),
                ),
              ),

              //  the Quantity button
              Expanded(
                child: MaterialButton(
                  onPressed: () {
                    ///this line
                    showDialog(
                        context: context,
                        builder: (context) {
                          return new AlertDialog(
                            title: new Text("quantity"),
                            content: new Text("choose the quantity"),
                            actions: <Widget>[
                              new MaterialButton(
                                onPressed: () {
                                  Navigator.of(context).pop(context);
                                },
                                child: new Text("close"),
                              )
                            ],
                          );
                        });
                  },
                  color: Colors.white,
                  textColor: Colors.grey,
                  elevation: 0.2,
                  child: Row(
                    children: <Widget>[
                      const Expanded(child: Text("Qty")),
                      Expanded(child: new Icon(Icons.arrow_drop_down)),
                    ],
                  ),
                ),
              ),
            ],
          ),

          //     ============== the secound buttons =========

          Row(
            children: <Widget>[
//  the side button
              Expanded(
                child: MaterialButton(
                  onPressed: () {
                    ///this line
                    showDialog(
                        context: context,
                        builder: (context) {
                          return new AlertDialog(
                            title: new Text("Try It Now"),
                            content: new Text(
                                "Do you want to try this dress in our virtual dressing room?"),
                            actions: <Widget>[
                              new MaterialButton(
                                onPressed: () {
                                  Navigator.of(context)
                                      .pop(); // Close the dialog
                                  Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) =>
                                              VirtualTryOnPage())); // Navigate to virtual try-on page
                                },
                                child: new Text("Yes"),
                              ),
                              new MaterialButton(
                                onPressed: () {
                                  Navigator.of(context)
                                      .pop(); // Close the dialog
                                },
                                child: new Text("No"),
                              ),
                            ],
                          );
                        });
                  },
                  color: Colors.blue,
                  textColor: Colors.white,
                  elevation: 0.2,
                  child: new Text("Buy now"),
                ),
              ),
              new IconButton(
                  icon: Icon(
                    Icons.add_shopping_cart,
                    color: Colors.blue,
                  ),
                  onPressed: () {}),
              new IconButton(
                  icon: Icon(
                    Icons.favorite_border,
                    color: Colors.blue,
                  ),
                  onPressed: () {}),
            ],
          ),

          Divider(),
          new ListTile(
            title: new Text("product details"),
            subtitle: new Text(
                "Lorem Ipsum is simply dummy text of the printing and typesetting industry. Lorem Ipsum has been the industry's standard dummy text ever since the 1500s, when an unknown printer took a galley of type and scrambled it to make a type specimen book. It has survived not only five centuries, but also the leap into electronic typesetting, remaining essentially unchanged."),
          ),

          Divider(),
          new Row(
            children: <Widget>[
              Padding(
                padding: const EdgeInsets.fromLTRB(12.0, 5.0, 5.0, 5.0),
                child: new Text(
                  "Product name",
                  style: TextStyle(color: Colors.grey),
                ),
              ),
              Padding(
                padding: EdgeInsets.all(5.0),
                child: new Text(widget.productDetailName),
              ),
            ],
          ),

          new Row(
            children: <Widget>[
              Padding(
                padding: const EdgeInsets.fromLTRB(12.0, 5.0, 5.0, 5.0),
                child: new Text(
                  "Product brand",
                  style: TextStyle(color: Colors.grey),
                ),
              ),
              // Remember to create the product brand
              Padding(
                padding: EdgeInsets.all(5.0),
                child: new Text("Brand"),
              ),
            ],
          ),

//        Add the product condition
          new Row(
            children: <Widget>[
              Padding(
                padding: const EdgeInsets.fromLTRB(12.0, 5.0, 5.0, 5.0),
                child: new Text(
                  "Product condition",
                  style: TextStyle(color: Colors.grey),
                ),
              ),
              Padding(
                padding: EdgeInsets.all(5.0),
                child: new Text("NEW"),
              ),
            ],
          ),

          Divider(),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: new Text("Similar products"),
          ),

          //Simple product section
          Container(
            height: 340.0,
            child: Similar_products(),
          )
        ],
      ),
    );
  }
}

class Similar_products extends StatefulWidget {
  @override
  State<Similar_products> createState() => _Similar_productsState();
}

class _Similar_productsState extends State<Similar_products> {
  var productList = [
    {
      "name": "Blazer",
      "picture": "images/products/blazer1.jpeg",
      "old_price": "120",
      "price": "85",
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
  ];

  @override
  Widget build(BuildContext context) {
    return GridView.builder(
      itemCount: productList.length,
      gridDelegate:
          SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 2),
      itemBuilder: (BuildContext context, int index) {
        return Similar_single_prod(
          prodName: productList[index]['name']!,
          prodPicture: productList[index]['picture']!,
          prodOldPrice: productList[index]['old_price']!,
          prodPrice: productList[index]['price']!,
        );
      },
    );
  }
}

class Similar_single_prod extends StatelessWidget {
  final String prodName;
  final String prodPicture;
  final String prodOldPrice;
  final String prodPrice;

  Similar_single_prod({
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
