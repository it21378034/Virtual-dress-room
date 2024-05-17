import 'package:flutter/material.dart';

class CartProducts extends StatefulWidget {
  const CartProducts({Key? key}) : super(key: key);

  @override
  State<CartProducts> createState() => _CartProductsState();
}

class _CartProductsState extends State<CartProducts> {
  // List of products in the cart
  List<Map<String, dynamic>> productsOnTheCart = [
    {
      "name": "Blazer",
      "picture": "images/products/blazer1.jpeg",
      "old_price": "120",
      "price": "85",
      "size": "M",
      "color": "Black",
      "quantity": 1,
    },
    {
      "name": "skt",
      "picture": "images/products/skt1.jpeg",
      "old_price": "100",
      "price": "50",
      "size": "M",
      "color": "Red",
      "quantity": 1,
    },
  ];

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: productsOnTheCart.length,
      itemBuilder: (context, index) {
        // Return a SingleCartProduct widget for each product
        return SingleCartProduct(
          cartprodName: productsOnTheCart[index]["name"],
          cartprodPicture: productsOnTheCart[index]["picture"],
          cartprodOldPrice: productsOnTheCart[index]["old_price"],
          cartprodPrice: productsOnTheCart[index]["price"],
          cartprodSize: productsOnTheCart[index]["size"],
          cartprodColor: productsOnTheCart[index]["color"],
          cartprodQty: productsOnTheCart[index]["quantity"].toString(),
        );
      },
    );
  }
}

class SingleCartProduct extends StatelessWidget {
  final String cartprodName;
  final String cartprodPicture;
  final String cartprodOldPrice;
  final String cartprodPrice;
  final String cartprodSize;
  final String cartprodColor;
  final String cartprodQty;

  const SingleCartProduct({
    required this.cartprodName,
    required this.cartprodPicture,
    required this.cartprodOldPrice,
    required this.cartprodPrice,
    required this.cartprodSize,
    required this.cartprodColor,
    required this.cartprodQty,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      child: ListTile(
        leading: Image.asset(
          cartprodPicture,
          width: 80.0,
          height: 100.0,
        ),
        title: Text(cartprodName),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Text("Size: $cartprodSize", style: TextStyle(color: Colors.red)),
            Text("Color: $cartprodColor", style: TextStyle(color: Colors.red)),
            Text("\$$cartprodPrice",
                style: TextStyle(
                    fontSize: 17.0,
                    fontWeight: FontWeight.bold,
                    color: Colors.red)),
          ],
        ),
        trailing: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            IconButton(
              icon: Icon(Icons.arrow_drop_up),
              onPressed: () {},
            ),
            Text(cartprodQty),
            IconButton(
              icon: Icon(Icons.arrow_drop_down),
              onPressed: () {},
            ),
          ],
        ),
      ),
    );
  }
}
