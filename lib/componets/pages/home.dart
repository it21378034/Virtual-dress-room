import 'package:carousel_slider/carousel_slider.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:virtual_dress_room/componets/cart/cart.dart';
// my own imports
import 'package:virtual_dress_room/componets/horizontal_listview.dart';
import 'package:virtual_dress_room/componets/product/products.dart';
import 'package:virtual_dress_room/componets/register/accoun_page.dart';
import 'package:virtual_dress_room/componets/shipping/shipping_details.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0.1,
        backgroundColor: Colors.blue,
        title: Text('Fashion App'),
        actions: <Widget>[
          IconButton(
            icon: Icon(
              Icons.shopping_cart,
              color: Colors.white,
            ),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => Cart()),
              );
              // Handle search action
            },
          ),
        ],
      ),
      drawer: Drawer(
        child: ListView(
          children: <Widget>[
            UserAccountsDrawerHeader(
              accountName: FutureBuilder(
                future: _getCurrentUserName(),
                builder:
                    (BuildContext context, AsyncSnapshot<String> snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return CircularProgressIndicator();
                  } else {
                    return Text(snapshot.data ?? '');
                  }
                },
              ),
              // Display user's name here
              accountEmail: FutureBuilder(
                future: _getCurrentUserEmail(),
                builder:
                    (BuildContext context, AsyncSnapshot<String> snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return CircularProgressIndicator();
                  } else {
                    return Text(snapshot.data ?? '');
                  }
                },
              ),
              currentAccountPicture: GestureDetector(
                child: CircleAvatar(
                  backgroundColor: Colors.grey,
                ),
              ),
            ),

            // Drawer items
            // Implement functionality for these items
            ListTile(
              title: Text('Home Page'),
              leading: Icon(
                Icons.home,
                color: Colors.blue,
              ),
              onTap: () {
                Navigator.pop(context); // Close the drawer
                // Implement navigation to home page if needed
              },
            ),
            ListTile(
              title: Text('Address'),
              leading: Icon(
                Icons.post_add_sharp,
                color: Colors.blue,
              ),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => ShippingDetailsPage()),
                  //ShippingDetailsPage
                );
              },
            ),
            ListTile(
              title: Text('My orders'),
              leading: Icon(
                Icons.shopping_basket,
                color: Colors.blue,
              ),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => Cart()),
                );
              },
            ),
            ListTile(
              title: Text('Favorites'),
              leading: Icon(
                Icons.favorite,
                color: Colors.blue,
              ),
              onTap: () {
                Navigator.pop(context); // Close the drawer
                // Implement navigation to favorites page if needed
              },
            ),
            Divider(),
            ListTile(
              title: Text('Settings'),
              leading: Icon(
                Icons.settings,
              ),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => AccountPage()),
                );
              },
            ),
            ListTile(
              title: Text('About'),
              leading: Icon(
                Icons.help,
              ),
            ),
            ListTile(
              title: Text('Sign Out'),
              leading: Icon(
                Icons.exit_to_app,
                color: Colors.red,
              ),
              onTap: () async {
                await _signOut();
                Navigator.pop(context); // Close the drawer
                // Navigate to the sign-in page or perform any other actions after sign-out
              },
            ),
          ],
        ),
      ),
      body: Column(
        children: <Widget>[
          // Carousel Slider
          CarouselSlider(
            items: [
              'images/c1.jpg',
              'images/c2.jpeg',
              'images/c3.jpeg',
            ].map((imagePath) {
              return Builder(
                builder: (BuildContext context) {
                  return Container(
                    width: MediaQuery.of(context).size.width,
                    margin: EdgeInsets.symmetric(horizontal: 5.0),
                    decoration: BoxDecoration(
                      color: Colors.grey,
                    ),
                    child: Image.asset(
                      imagePath,
                      fit: BoxFit.cover,
                    ),
                  );
                },
              );
            }).toList(),
            options: CarouselOptions(
              height: 200.0,
              autoPlay: true,
              autoPlayCurve: Curves.fastOutSlowIn,
              enableInfiniteScroll: true,
              autoPlayAnimationDuration: Duration(milliseconds: 1000),
              viewportFraction: 0.8,
            ),
          ),

          // ListView
          Expanded(
            child: ListView(
              children: <Widget>[
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text('Categories'),
                ),
                // Horizontal list view begins here
                HorizontalList(),

                Padding(
                  padding: const EdgeInsets.all(25.0),
                  child: Text('Recent products'),
                ),

                // Grid view
                Container(
                  height: 320.0,
                  child: Products(),
                )

                // Add category items here
              ],
            ),
          ),
        ],
      ),
    );
  }

  Future<void> _signOut() async {
    await _auth.signOut();
  }

  Future<String> _getCurrentUserName() async {
    User? user = _auth.currentUser;
    if (user != null) {
      return user.displayName ?? '';
    }
    return '';
  }

////
  Future<String> _getCurrentUserEmail() async {
    User? user = _auth.currentUser;
    if (user != null) {
      return user.email ?? '';
    }
    return '';
  }
}
