// ignore_for_file: prefer_const_literals_to_create_immutables, prefer_const_constructors, argument_type_not_assignable_to_error_handler

import 'package:e_comm_tata/data_fetching_api_calls/wishlist_api_call/wishlist_item_details_holder.dart';
import 'package:e_comm_tata/widgets/search/pill_button.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../data_fetching_api_calls/cart_item_api_calls/wishlist_cart_api.dart';
import '../../data_fetching_api_calls/pdp_data_fetch_api_call/pdp_add_to_cart_api.dart';
import '../../utils/exception_handling/CustomException.dart';
import '../../utils/wislist_state_management/wishlist_delete.dart';

class WishlistItems extends StatelessWidget {
  WishlistItemDetailsHolder wishlistItemDetailsHolder;
  int index;
  List<WishlistItemDetailsHolder> loadedWishList;
  WishlistItems(
      this.wishlistItemDetailsHolder, this.index, this.loadedWishList);

  @override
  Widget build(BuildContext context) {
    return Material(
      elevation: 100,
      color: Theme.of(context).colorScheme.secondary,
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Image.network(wishlistItemDetailsHolder.imageUrl,
                fit: BoxFit.fitHeight),
            Row(mainAxisAlignment: MainAxisAlignment.center, children: [
              Text(
                  wishlistItemDetailsHolder.name.length >= 25
                      ? wishlistItemDetailsHolder.name.substring(0, 25)
                      : wishlistItemDetailsHolder.name,
                  softWrap: false,
                  maxLines: 1,
                  overflow: TextOverflow.fade),
            ]),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(wishlistItemDetailsHolder.price.toStringAsFixed(1)),
                Text(wishlistItemDetailsHolder.countInStock == 0
                    ? "Out of stock"
                    : "In stock"),
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                TextButton(
                  onPressed: () async {
                    try {
                      await PdpAddToCartApi()
                          .addToCartAPICall(wishlistItemDetailsHolder.skuId, 1);
                      showDialog(
                          context: context,
                          builder: (ctx) {
                            return AlertDialog(
                              title: Text("Success!"),
                              content: Text("Item added to cart"),
                              actions: [
                                TextButton(
                                  onPressed: () {
                                    Navigator.of(context).pop();
                                  },
                                  child: Text("OK"),
                                ),
                              ],
                            );
                          });
                    } on CustomException catch (error) {
                      showDialog(
                          context: context,
                          builder: (ctx) {
                            return AlertDialog(
                              title: Text("Error!"),
                              content: Text(error.cause),
                              actions: [
                                TextButton(
                                  onPressed: () {
                                    Navigator.of(context).pop();
                                  },
                                  child: Text("OK"),
                                ),
                              ],
                            );
                          });
                    } catch (error) {
                      return showDialog(
                          context: context,
                          builder: (ctx) {
                            return AlertDialog(
                              title: Text("Error!"),
                              content: Text("Some error Occured"),
                              actions: [
                                TextButton(
                                  onPressed: () {
                                    Navigator.of(context).pop();
                                  },
                                  child: Text("OK"),
                                ),
                              ],
                            );
                          });
                    }
                  },
                  style: TextButton.styleFrom(
                      backgroundColor: Theme.of(context).colorScheme.tertiary),
                  child: Text(
                    "Add to Cart",
                    style: TextStyle(color: Colors.white),
                  ),
                ),
                TextButton(
                  style: TextButton.styleFrom(alignment: Alignment.centerRight),
                  onPressed: () {
                    Provider.of<WishListDelete>(context, listen: false)
                        .deleteWishList(index, loadedWishList)
                        .then((value) {
                      showDialog(
                          context: context,
                          builder: (ctx) {
                            return AlertDialog(
                              title: Text("Success"),
                              content: Text("Deleted from wishlist"),
                            );
                          });
                    }).catchError((error) {
                      showDialog(
                          context: context,
                          builder: (ctx) {
                            return AlertDialog(
                              title: Text("Error!"),
                              content: Text("Failed To delete"),
                              actions: [
                                TextButton(
                                  onPressed: () {
                                    Navigator.of(context).pop();
                                  },
                                  child: Text("OK"),
                                ),
                              ],
                            );
                          });
                    });
                  },
                  child: Icon(Icons.delete, color: Colors.red),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
