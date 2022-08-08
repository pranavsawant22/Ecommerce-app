// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables

import 'package:e_comm_tata/screens/cart_checkout/cart_screen.dart';
import 'package:e_comm_tata/screens/wishlist/empty_wishlist_page.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../data_fetching_api_calls/wishlist_api_call/get_wishlist.dart';
import '../../data_fetching_api_calls/wishlist_api_call/wishlist_details_holder.dart';
import '../../data_fetching_api_calls/wishlist_api_call/wishlist_item_details_holder.dart';
import '../../utils/bottom_navbar/bottom_navbar_util.dart';
import '../../utils/bottom_navbar/page_index.dart';
import '../../utils/wislist_state_management/wishlist_delete.dart';
import '../../widgets/wishlist/wishlist_items.dart';

class Wishlist extends StatefulWidget {
  static String routeName = "/wishlist";
  @override
  State<Wishlist> createState() => _WishlistState();
}

class _WishlistState extends State<Wishlist> {
  @override
  Widget build(BuildContext context) {
    final getWishlistAPIProvider =
        Provider.of<GetWishlistAPI>(context, listen: false);
    bool initialised = false;
    return Scaffold(
      appBar: AppBar(
        actions: [
          TextButton(
              onPressed: () {
                Navigator.pushReplacementNamed(context, CartScreen.routeName);
              },
              child: Icon(
                Icons.shopping_cart,
                color: Colors.white,
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
        child: FutureBuilder(
          future: getWishlistAPIProvider.getWishlistAPICall(),
          builder: (context, AsyncSnapshot<WishlistDetailsHolder> snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return Center(
                child: CircularProgressIndicator(
                  color: Colors.red,
                ),
              );
            }

            if (snapshot.hasData == true) {
              List<WishlistItemDetailsHolder> wishListItems = [];

              return Consumer<WishListDelete>(
                builder: (context, wishListDeleteSnapshot, child) {
                  if (initialised == false) {
                    wishListDeleteSnapshot
                        .initialiseWishList(snapshot.data!.wishlistitems);
                    wishListItems = wishListDeleteSnapshot.getUpdateWishList();
                    initialised = true;
                  } else {
                    wishListItems =
                        Provider.of<WishListDelete>(context, listen: false)
                            .getUpdateWishList();
                  }

                  if (wishListItems.length == 0) {
                    return Container(
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
                              'assets/images/icons/wishlist/empty_wishlist.png',
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
                                color: Color(0xFF000000),
                                fontSize: 30,
                                fontStyle: FontStyle.italic,
                              ),
                              textAlign: TextAlign.center,
                            ),
                          ),
                        ],
                      ),
                    );
                  }

                  return GridView.count(
                      primary: false,
                      padding: const EdgeInsets.all(6),
                      crossAxisSpacing: 10,
                      mainAxisSpacing: 10,
                      childAspectRatio: 0.6,
                      crossAxisCount: 2,
                      children: snapshot.data!.wishlistitems
                          .asMap()
                          .entries
                          .map((wishlistitem) {
                        return WishlistItems(wishlistitem.value,
                            wishlistitem.key, wishListItems);
                      }).toList());
                },
              );
              // children: <Widget>[
              //   WishlistItems(),
              //   WishlistItems(),
              //   WishlistItems(),
              //   WishlistItems(),
              //   WishlistItems(),
              //   WishlistItems(),
              //   WishlistItems(),
              //   WishlistItems(),
              //   WishlistItems(),
              //   WishlistItems(),

            } else {
              return Container(
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
                        'assets/images/icons/wishlist/empty_wishlist.png',
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
                          color: Color(0xFF000000),
                          fontSize: 30,
                          fontStyle: FontStyle.italic,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ),
                  ],
                ),
              );
            }
          },
        ),
      ),
      bottomNavigationBar:
          BottomNavbarUtil(index: pageIndex["wishlist"] as int),
    );
  }
}
