import 'package:e_comm_tata/utils/cart_checkout/cart_checkout_body.dart';
import 'package:e_comm_tata/utils/cart_checkout/check_out_card_BottomBar.dart';
import 'package:e_comm_tata/widgets/cart_checkout/checkout_bottom_bar.dart';
import 'package:flutter/material.dart';

import '../../utils/cart_checkout/Cart.dart';

class CheckoutScreen extends StatelessWidget {
  static String routeName = "/checkout";
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: buildAppBar(context),
      body: CartCheckoutBody(),
      bottomNavigationBar: CheckoutBottomBar(),
    );
  }

  AppBar buildAppBar(BuildContext context) {
    return AppBar(
      backgroundColor: Color(0xFF2C2C2C),
      title: Column(
        children: [
          Text(
            "Checkout",
            style: TextStyle(color: Colors.white),
          ),
        ],
      ),
    );
  }
}
