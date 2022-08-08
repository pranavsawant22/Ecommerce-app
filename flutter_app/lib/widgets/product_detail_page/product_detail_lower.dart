// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../data_fetching_api_calls/cart_item_api_calls/wishlist_cart_api.dart';
import '../../data_fetching_api_calls/check_user_logged_in_api_call/check_user_logged_in.dart';
import '../../data_fetching_api_calls/wishlist_api_call/remove_wishlist_item.dart';
import '../../utils/exception_handling/CustomException.dart';
import '../../widgets/product_detail_page/product_detail_review_rating.dart';
import '../../widgets/product_detail_page/product_heading.dart';
import '../../widgets/product_detail_page/product_long_description.dart';
import '../../widgets/product_detail_page/product_short_description.dart';

class ProductDetailLower extends StatefulWidget {
  Map<String, dynamic> productDetailDataMap;
  ProductDetailLower(this.productDetailDataMap, {Key? key}) : super(key: key);

  @override
  State<ProductDetailLower> createState() => _ProductDetailLowerState();
}

class _ProductDetailLowerState extends State<ProductDetailLower> {
  Future<void> toggleFavouriteButton(
      bool favouriteStatus, String skuId, String kind) async {
    String jwtToken = "";
    if (await CheckUserLoggedInAPI.checkUserLogInAPICall() == true) {
      final sharedPreference = await SharedPreferences.getInstance();
      jwtToken = sharedPreference.getString('jwt')!;

      if (favouriteStatus == false) {
        try {
          String wishlistStatus =
              await WishlistCartItemAPI().wishlistCartAPICallStatus(skuId);

          showDialog(
            context: context,
            barrierDismissible: false,
            builder: (context) {
              return AlertDialog(
                title: Text(
                  'Success',
                  style: TextStyle(color: Colors.white),
                ),
                content: Text(wishlistStatus),
                actions: <Widget>[
                  Center(
                    child: TextButton(
                      style: TextButton.styleFrom(backgroundColor: Colors.grey),
                      child: const Text('Okay',
                          style: TextStyle(color: Colors.black87)),
                      onPressed: () {
                        Navigator.of(context).pop();
                      },
                    ),
                  ),
                ],
              );
            },
          );

          setState(() {
            widget.productDetailDataMap["isFavourite"] = true;
          });
        } on CustomException catch (error) {
          showDialog(
            context: context,
            barrierDismissible: false,
            builder: (context) {
              return AlertDialog(
                title: Text(
                  'Error!',
                  style: TextStyle(color: Colors.white),
                ),
                content: Text(error.cause),
                actions: <Widget>[
                  Center(
                    child: TextButton(
                      style: TextButton.styleFrom(backgroundColor: Colors.grey),
                      child: const Text('Okay',
                          style: TextStyle(color: Colors.black87)),
                      onPressed: () {
                        Navigator.of(context).pop();
                      },
                    ),
                  ),
                ],
              );
            },
          );
        } catch (error) {
          showDialog(
            context: context,
            barrierDismissible: false,
            builder: (context) {
              return AlertDialog(
                title: Text(
                  'Error!',
                  style: TextStyle(color: Colors.white),
                ),
                content: Text('Some Error Occured'),
                actions: <Widget>[
                  Center(
                    child: TextButton(
                      style: TextButton.styleFrom(backgroundColor: Colors.grey),
                      child: const Text('Okay',
                          style: TextStyle(color: Colors.black87)),
                      onPressed: () {
                        Navigator.of(context).pop();
                      },
                    ),
                  ),
                ],
              );
            },
          );
        }
      } else {
        showDialog(
            context: context,
            builder: (ctx) {
              return AlertDialog(
                title: Text("Warning"),
                content: Text("Do you want to remove from wishlist?"),
                actions: [
                  TextButton(
                    onPressed: () {
                      Navigator.of(context).pop(true);
                    },
                    child: Text("Delete"),
                  ),
                  TextButton(
                    onPressed: () {
                      Navigator.of(context).pop(false);
                    },
                    child: Text("Cancel"),
                  ),
                ],
              );
            }).then((value) {
          if (value == true) {
            DeleteWishlistItemAPI.deleteWishlistItemAPICall(skuId).then((_) {
              showDialog(
                context: context,
                barrierDismissible: false,
                builder: (context) {
                  return AlertDialog(
                    title: Text(
                      'Success!',
                      style: TextStyle(color: Colors.white),
                    ),
                    content: Text('Item Removed from wishlist'),
                    actions: <Widget>[
                      Center(
                        child: TextButton(
                          style: TextButton.styleFrom(
                              backgroundColor: Colors.grey),
                          child: const Text('Okay',
                              style: TextStyle(color: Colors.black87)),
                          onPressed: () {
                            Navigator.of(context).pop();
                          },
                        ),
                      ),
                    ],
                  );
                },
              );

              setState(() {
                widget.productDetailDataMap["isFavourite"] = false;
              });
            }).onError((error, stackTrace) {
              showDialog(
                context: context,
                barrierDismissible: false,
                builder: (context) {
                  return AlertDialog(
                    title: Text(
                      'Error!',
                      style: TextStyle(color: Colors.white),
                    ),
                    content: Text('Some Error Occured'),
                    actions: <Widget>[
                      Center(
                        child: TextButton(
                          style: TextButton.styleFrom(
                              backgroundColor: Colors.grey),
                          child: const Text('Okay',
                              style: TextStyle(color: Colors.black87)),
                          onPressed: () {
                            Navigator.of(context).pop();
                          },
                        ),
                      ),
                    ],
                  );
                },
              );
            });
          }
        });
      }
    } else {
      showDialog(
        context: context,
        barrierDismissible: false,
        builder: (context) {
          return AlertDialog(
            title: Text(
              'Error!',
              style: TextStyle(color: Colors.white),
            ),
            content: Text('Please Log in to add/remove from wishlist'),
            actions: <Widget>[
              Center(
                child: TextButton(
                  style: TextButton.styleFrom(backgroundColor: Colors.grey),
                  child: const Text('Okay',
                      style: TextStyle(color: Colors.black87)),
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                ),
              ),
            ],
          );
        },
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    List<Map<String, dynamic>> reviews =
        widget.productDetailDataMap["ratingReviews"];
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.secondary,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(50),
          topRight: Radius.circular(50),
        ),
      ),
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 35, vertical: 30),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ProductHeading(
              ratingAvg:
                  widget.productDetailDataMap["productRating"].toString(),
              productName: widget.productDetailDataMap["productSkuName"],
            ),
            SizedBox(
              height: 15,
            ),
            ProductShortDescription(
              description: widget.productDetailDataMap["productDescription"],
            ),
            SizedBox(
              height: 15,
            ),
            Container(
              alignment: Alignment.centerLeft,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    "₹ ${widget.productDetailDataMap["itemPrice"]}",
                    style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold),
                  ),
                  IconButton(
                    onPressed: () {
                      toggleFavouriteButton(
                          widget.productDetailDataMap["isFavourite"],
                          "${widget.productDetailDataMap["kind"]}:${widget.productDetailDataMap["slug"]["current"]}",
                          widget.productDetailDataMap["kind"]);
                    },
                    icon: widget.productDetailDataMap["isFavourite"] == false
                        ? Icon(Icons.favorite_outline)
                        : Icon(
                            Icons.favorite,
                            color: Colors.red,
                          ),
                  )
                ],
              ),
            ),
            SizedBox(
              height: 10,
            ),
            Divider(),
            Text(
              "Description",
              style: TextStyle(fontSize: 25),
            ),
            SizedBox(
              height: 5,
            ),
            ProductLongDescription(
                description:
                    'The Motorola Edge Fusion 20 has a 108 MP Quad Function Camera System that helps include a lot more in the frame with its wide-angle lens. You can also get close to the subject using the macro vision lens. With 128 GB built-in storage so that you can store and save your data. And, with a powerful 5000 mAh battery, you can enjoy up to 12 hours of power after charging the mobile phone for 10 minutes.'),
            SizedBox(
              height: 15,
            ),
            Divider(),
            Text(
              "Ratings & Reviews",
              style: TextStyle(fontSize: 25),
            ),
            SizedBox(
              height: 5,
            ),
            ...reviews.map((reviewData) {
              return reviewData["rating"] == -1
                  ? Container(
                      child: Text("No Reviews and Ratings"),
                    )
                  : ProductDetailRatingReview(
                      userName: reviewData["firstName"] +
                          " " +
                          reviewData["lastName"],
                      rating: reviewData["rating"],
                      review: reviewData["comment"] ?? "",
                    );
            }).toList(),
            Container(
              height: 100,
            )
          ],
        ),
      ),
    );
  }
}
