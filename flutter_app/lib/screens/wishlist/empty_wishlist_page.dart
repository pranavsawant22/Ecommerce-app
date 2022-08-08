import 'package:flutter/material.dart';

class EmptyWishListScreen extends StatefulWidget {
  static String routeName = "/empty_wishlist";
  @override
  State<EmptyWishListScreen> createState() => _EmptyWishListScreenState();
}

class _EmptyWishListScreenState extends State<EmptyWishListScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color(0xFFFFFF),
        leading: Icon(
          Icons.arrow_circle_left,
          size: 30.0,
        ),
        actions: [
          TextButton(
              onPressed: () {},
              child: Icon(
                Icons.shopping_cart,
                size: 30.0,
              ))
        ],
        centerTitle: true,
        title: Text(
          "WishList",
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20.0),
        ),
      ),
      body: Container(
        decoration: BoxDecoration(color: Colors.white),
        child: Column(
          children: <Widget>[
            SizedBox(
              height: 70,
              child: Container(
                color: Color(0xFFFFFFFF),
              ),
            ),
            Container(
              width: double.infinity,
              padding: EdgeInsets.fromLTRB(0.0, 20.0, 0.0, 0.0),
              height: 300,
              child: Image.asset(
                'images/empty_wishlist.png',
                height: 250,
                width: double.infinity,
              ),
            ),
            SizedBox(
              height: 40,
              child: Container(color: Color(0xFFFFFFFF)),
            ),
            Container(
              width: double.infinity,
              child: Text(
                "Make a Wish soon",
                style: TextStyle(
                  color: Color(0xFFDCEDC8),
                  fontSize: 30,
                  fontStyle: FontStyle.italic,
                ),
                textAlign: TextAlign.center,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
