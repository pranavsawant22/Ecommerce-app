// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables

import 'package:e_comm_tata/widgets/cart_checkout/cart_checkout_dropdown_buttons.dart';
import 'package:flutter/material.dart';

import '../../screens/landing_page/landing_page.dart';
import '../../utils/cart_checkout/default_button.dart';
import '../../utils/size_config.dart';

class CheckoutBottomBar extends StatelessWidget {
  const CheckoutBottomBar({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);
    return Container(
      padding: EdgeInsets.symmetric(
        vertical: getProportionateScreenWidth(15),
        horizontal: getProportionateScreenWidth(30),
      ),
      // height: 174,
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.secondary,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(30),
          topRight: Radius.circular(30),
        ),
        boxShadow: [
          BoxShadow(
            offset: Offset(0, -15),
            blurRadius: 20,
            color: Theme.of(context).colorScheme.secondary.withOpacity(0.15),
          )
        ],
      ),
      child: SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(height: getProportionateScreenHeight(20)),
            CartCheckoutDropdownButtonAddress(
                updateSelectedAddress: () {},
                icon: Icon(Icons.pin_drop),
                s1: "Address",
                options: ["Address 1", "Address 2", "Address 3"]),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text.rich(
                  TextSpan(
                    text: "Total:\n",
                    children: [
                      TextSpan(
                        text: "\$337.15",
                        style: TextStyle(fontSize: 16, color: Colors.black),
                      ),
                    ],
                  ),
                ),
                SizedBox(
                  width: getProportionateScreenWidth(190),
                  child: DefaultButton(
                    color: Theme.of(context).colorScheme.tertiary,
                    text: "Buy Now",
                    press: () {
                      // showDialog(
                      //   context: context,
                      //   builder: (ctx) => AlertDialog(
                      //     title: const Text("Order Placed"),
                      //     content: const Text("Thank you"),
                      //     actions: <Widget>[
                      //       TextButton(
                      //         onPressed: () {
                      //           Navigator.pushReplacementNamed(
                      //               context, LandingPage.routeName);
                      //         },
                      //         child: Container(
                      //           color: Color(0xFF2C2C2C),
                      //           padding: const EdgeInsets.all(14),
                      //           child: const Text(
                      //             "Done",
                      //             style: TextStyle(color: Colors.white),
                      //           ),
                      //         ),
                      //       )
                      //     ],
                      //   ),
                      // );
                    },
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
