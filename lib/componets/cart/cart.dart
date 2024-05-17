import 'package:flutter/material.dart';
import 'package:virtual_dress_room/componets/cart/cart_products.dart';
import 'package:virtual_dress_room/componets/shipping/select_shipping_address.dart';

class Cart extends StatefulWidget {
  const Cart({Key? key}) : super(key: key);

  @override
  _CartState createState() => _CartState();
}

class _CartState extends State<Cart> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0.1,
        backgroundColor: Colors.blue,
        title: Text('Cart'),
        actions: <Widget>[
          IconButton(
            icon: const Icon(
              Icons.search,
              color: Colors.white,
            ),
            onPressed: () {
              // Handle search action
            },
          ),
        ],
      ),
      body: CartProducts(),
      bottomNavigationBar: new Container(
        color: Colors.white,
        child: Row(
          children: <Widget>[
            Expanded(
              child: ListTile(
                title: new Text("Total:"),
                subtitle: new Text("\$230"),
              ),
            ),
            Expanded(
              child: MaterialButton(
                onPressed: () {
                  // Navigate to the Shipping Details page
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => SelectPaymentAddressPage()),
                  );
                },
                child: Text("Check out", style: TextStyle(color: Colors.white)),
                color: Colors.blue,
              ),
            ), // MaterialButton
          ],
        ),
      ),
    );
  }
}
