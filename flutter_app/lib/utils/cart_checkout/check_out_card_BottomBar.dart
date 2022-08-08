// ignore_for_file: prefer_const_constructors, use_build_context_synchronously

import 'dart:ui';

import 'package:e_comm_tata/sanity_api_call/inventory_update_sanity/invetory_update.dart';
import 'package:e_comm_tata/utils/cart_checkout/models/address_holder.dart';
import 'package:e_comm_tata/utils/cart_checkout/models/cart_item_detail_holder.dart';
import 'package:e_comm_tata/widgets/cart_checkout/cart_checkout_dropdown_buttons.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:provider/provider.dart';

import '../../data_fetching_api_calls/cart_item_api_calls/buy_now_api.dart';
import '../../data_fetching_api_calls/user_profile_api_call/get_address_api.dart';
import '../../screens/cart_checkout/checkout_screen.dart';
import '../../screens/landing_page/landing_page.dart';
import '../../widgets/auth/common_widgets/default_button.dart';
import '../size_config.dart';
import 'delete_and_quantity_change_ui_update_logic/delete_and_quantity_ui_update_logic_cart.dart';

class CheckoutCardBottomBar extends StatelessWidget {
  List<CartItemsDetailsHolder> itemDetails;
  CheckoutCardBottomBar(
    this.itemDetails, {
    Key? key,
  }) : super(key: key);

  String orderAddress = "";
  List<AddressHolder> addressList = [];

  void updateSelectedAddress(String newAddress) {
    orderAddress = newAddress;
  }

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
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(30),
          topRight: Radius.circular(30),
        ),
        boxShadow: [
          BoxShadow(
            offset: const Offset(0, -15),
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
            FutureBuilder(
              future: GetAddressAPI.getAddressAPICall(),
              builder: (ctx, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return Text("Please wait");
                }

                List data = snapshot.data == null ? [] : snapshot.data as List;
                List<AddressHolder> addressdata = [];
                for (int i = 0; i < data.length; i++) {
                  addressdata.add(
                    AddressHolder(
                      name: data[i]["name"],
                      addressId: data[i]["_id"],
                      buildingInfo: data[i]["buildingInfo"],
                      city: data[i]["city"],
                      pincode: data[i]["pincode"],
                      serialId: data[i]["serialId"].toString(),
                      state: data[i]["state"],
                      landmark: data[i]["landmark"] ?? "",
                    ),
                  );
                }
                addressList = addressdata;
                return CartCheckoutDropdownButtonAddress(
                    updateSelectedAddress: updateSelectedAddress,
                    icon: const Icon(Icons.pin_drop),
                    s1: "Address",
                    options: addressdata.map((e) {
                      return e.addressCreate();
                    }).toList());
              },
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Consumer<DeleteQuantityChangeUiUpdate>(
                  builder: (BuildContext ctx, snapshot, child) {
                    return Text.rich(
                      TextSpan(
                        text: "Total:\n",
                        children: [
                          TextSpan(
                            text: "${snapshot.price}",
                            style: TextStyle(
                                fontSize: 20,
                                color: Colors.white,
                                fontWeight: FontWeight.bold),
                          ),
                        ],
                      ),
                    );
                  },
                ),
                SizedBox(
                  width: getProportionateScreenWidth(190),
                  child: DefaultButton(
                    text: "Buy Now",
                    press: () async {
                      int i;
                      AddressHolder addressObject;
                      Map<String, dynamic> addressMap = {};
                      for (i = 0; i < addressList.length; i++) {
                        if (addressList[i].addressCreate() == orderAddress) {
                          addressObject = addressList[i];
                          addressMap = {
                            "name": addressObject.name,
                            "buildingInfo": addressObject.buildingInfo,
                            "state": addressObject.state,
                            "city": addressObject.city,
                            "landmark": addressObject.landmark,
                            "pincode": addressObject.pincode,
                          };
                        }
                      }
                      int j;
                      List<CartItemsDetailsHolder> cartItemsList =
                          Provider.of<DeleteQuantityChangeUiUpdate>(context,
                                  listen: false)
                              .getUpdateCartList();
                      List<Map<String, dynamic>> cartItemsOrderPlace = [];
                      for (i = 0; i < cartItemsList.length; i++) {
                        if (cartItemsList[i].countInStock > 0) {
                          for (j = 0; j < cartItemsList[i].quantity; j++) {
                            cartItemsOrderPlace.add({
                              "sku_id": cartItemsList[i].skuId,
                              "price": cartItemsList[i].price
                            });
                          }
                        }
                      }

                      if (cartItemsOrderPlace.length == 0) {
                        return;
                      }
                      Map<String, dynamic> placeOrderData = {
                        "address": addressMap,
                        "total_price":
                            Provider.of<DeleteQuantityChangeUiUpdate>(context,
                                    listen: false)
                                .price,
                        "items": cartItemsOrderPlace,
                        "status": "NOT_SHIPPED"
                      };

                      try {
                        bool orderPlaceStatus = await BuyNowCartItemAPI()
                            .buyNowCartAPICall(placeOrderData, cartItemsList);

                        if (orderPlaceStatus == true) {
                          Provider.of<DeleteQuantityChangeUiUpdate>(context,
                                  listen: false)
                              .deleteAllCartItems(cartItemsOrderPlace)
                              .then((value) {
                            showDialog(
                                context: context,
                                builder: (ctx) {
                                  return AlertDialog(
                                    title: Text("Success!"),
                                    content: Text("Order placed!"),
                                    actions: [
                                      TextButton(
                                        onPressed: () {
                                          Navigator.of(context).pop();
                                        },
                                        child: Text("Ok"),
                                      ),
                                    ],
                                  );
                                });
                          }).onError((error, stackTrace) {
                            showDialog(
                                context: context,
                                builder: (ctx) {
                                  return AlertDialog(
                                    title: Text("Success!"),
                                    content: Text(
                                        "Order placed!,But some Items Not Deleted from cart"),
                                    actions: [
                                      TextButton(
                                        onPressed: () {
                                          Navigator.of(context).pop();
                                        },
                                        child: Text("Ok"),
                                      ),
                                    ],
                                  );
                                });
                          });
                        }
                      } catch (error) {
                        showDialog(
                            context: context,
                            builder: (ctx) {
                              return AlertDialog(
                                title: Text("Failed"),
                                content: Text("Order Not placed!"),
                                actions: [
                                  TextButton(
                                    onPressed: () {
                                      Navigator.of(context).pop();
                                    },
                                    child: Text("Ok"),
                                  ),
                                ],
                              );
                            });
                      }
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
