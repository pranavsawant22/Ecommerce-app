import 'package:e_comm_tata/utils/cart_checkout/cart_checkout_body.dart';
import 'package:e_comm_tata/utils/cart_checkout/check_out_card_BottomBar.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../utils/bottom_navbar/bottom_navbar_util.dart';
import '../../utils/bottom_navbar/page_index.dart';
import '../../utils/cart_checkout/Cart.dart';

class CartScreen extends StatelessWidget {
  static String routeName = "/cart";
  @override
  Widget build(BuildContext context) {
    // final getallCartItems = Provider.of<GetCartItemsAPI>(context, listen: false);

    return SafeArea(
      child: Scaffold(
        appBar: buildAppBar(context),
        body: CartCheckoutBody(),
        bottomNavigationBar: Container(
          child: BottomNavbarUtil(index: pageIndex["cart"] as int),
        ),
      ),
    );
  }

  AppBar buildAppBar(BuildContext context) {
    return AppBar(
      title: Column(
        children: [
          Text(
            "Your Cart",
            style: TextStyle(color: Colors.white),
          ),
        ],
      ),
    );
  }
}
