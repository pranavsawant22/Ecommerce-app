// ignore_for_file: prefer_const_constructors

import 'package:e_comm_tata/data_fetching_api_calls/cart_item_api_calls/delete_cart_api.dart';
import 'package:e_comm_tata/screens/wishlist/wish_list.dart';
import 'package:e_comm_tata/utils/cart_checkout/delete_and_quantity_change_ui_update_logic/delete_and_quantity_ui_update_logic_cart.dart';
import 'package:e_comm_tata/utils/exception_handling/CustomException.dart';
import 'package:e_comm_tata/utils/exception_handling/cart_empty_exception.dart';
import 'package:e_comm_tata/widgets/cart_checkout/cart_checkout_product_items.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:provider/provider.dart';

import '../../data_fetching_api_calls/cart_item_api_calls/get_cart_items_api.dart';
import '../../data_fetching_api_calls/cart_item_api_calls/wishlist_cart_api.dart';
import '../../screens/cart_checkout/cart_screen.dart';
import '../size_config.dart';
import 'Cart.dart';
import '../../utils/cart_checkout/models/cart_item_holder.dart';
import '../../utils/cart_checkout/models/cart_item_detail_holder.dart';
import 'check_out_card_BottomBar.dart';

class CartCheckoutBody extends StatefulWidget {
  @override
  _CartCheckoutBodyState createState() => _CartCheckoutBodyState();
}

class _CartCheckoutBodyState extends State<CartCheckoutBody> {
  void wishlistItem(String productSku) async {
    try {
      String wishlistStatus =
          await WishlistCartItemAPI().wishlistCartAPICallStatus(productSku);

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
  }

  @override
  Widget build(BuildContext context) {
    // final getCartItemAPIProvider = Provider.of<GetCartItemsAPI>(context, listen: false);
    bool initialise = false;
    // getdata();
    SizeConfig().init(context);
    return FutureBuilder(
        future: Provider.of<GetCartItemsAPI>(context).getcartapicall(),
        // future: getCartItemAPIProvider.getcartapicall(),
        builder: (context, AsyncSnapshot<CartDetailsHolder?> snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(
              child: CircularProgressIndicator(
                color: Colors.white,
              ),
            );
          } else if (snapshot.hasData) {
            List<CartItemsDetailsHolder> cartitems;
            cartitems = snapshot.data!.itemDetails;

            double heightAvailable = MediaQuery.of(context).size.height -
                MediaQuery.of(context).padding.top -
                MediaQuery.of(context).padding.bottom;
            return Padding(
              padding: EdgeInsets.symmetric(
                  horizontal: getProportionateScreenWidth(20)),
              child: Container(
                height: heightAvailable,
                child: Column(
                  children: [
                    Container(
                      height: heightAvailable * 0.60,
                      child: Consumer<DeleteQuantityChangeUiUpdate>(
                          builder: (context, uiUpdateSnapshot, child) {
                        if (initialise == false) {
                          uiUpdateSnapshot
                              .initialiseCart(snapshot.data!.itemDetails);
                          cartitems = uiUpdateSnapshot.getUpdateCartList();
                        } else {
                          cartitems = uiUpdateSnapshot.getUpdateCartList();
                        }

                        return cartitems.length == 0
                            ? Center(
                                child: Text(
                                  "No Items in cart!",
                                  style: TextStyle(fontSize: 20),
                                ),
                              )
                            : ListView.builder(
                                itemCount:
                                    uiUpdateSnapshot.getUpdateCartList().length,
                                itemBuilder: (context, index) => Padding(
                                  padding: EdgeInsets.symmetric(vertical: 10),
                                  child: CartCheckoutProductItems(
                                      index: index,
                                      cartItems:
                                          uiUpdateSnapshot.getUpdateCartList(),
                                      cart: uiUpdateSnapshot
                                          .getUpdateCartList()[index],
                                      wishlistItem: wishlistItem),
                                ),
                              );
                      }),
                    ),
                    Expanded(
                      child: Container(
                        child: CheckoutCardBottomBar(cartitems),
                      ),
                    ),
                  ],
                ),
              ),
            );
          } else if (snapshot.hasError) {
            if (snapshot.error is CartEmptyException) {
              return Center(child: Text("Please add cart Item"));
            }
            var error = snapshot.error;
            return Text('$error');
          } else {
            return Text('No items found');
          }
          ;
        });
  }
}
