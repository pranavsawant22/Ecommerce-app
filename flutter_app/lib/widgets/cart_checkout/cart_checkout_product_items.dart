// ignore_for_file: prefer_const_literals_to_create_immutables, prefer_const_constructors

import 'package:e_comm_tata/widgets/cart_checkout/cart_checkout_dropdown_buttons.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../utils/cart_checkout/delete_and_quantity_change_ui_update_logic/delete_and_quantity_ui_update_logic_cart.dart';
import '../../utils/cart_checkout/models/cart_item_detail_holder.dart';
import '../../utils/constants/user_profile_cart_checkout/constants.dart';
import '../../utils/cart_checkout/Cart.dart';
import '../../utils/size_config.dart';
import '../../screens/cart_checkout/cart_screen.dart';
// import '../../editprofile/components/profile_menu.dart';

class CartCheckoutProductItems extends StatelessWidget {
  CartCheckoutProductItems({
    Key? key,
    required this.cart,
    required this.wishlistItem,
    required this.cartItems,
    required this.index,
  }) : super(key: key);

  // final Cart cart;
  final CartItemsDetailsHolder cart;
  Function wishlistItem;

  int index;
  List<CartItemsDetailsHolder> cartItems;
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 8.0),
      child: Row(
        children: [
          SizedBox(
            width: 100,
            child: AspectRatio(
              aspectRatio: 0.88,
              child: Container(
                child: Image.network(
                  cart.imageUrl,
                  fit: BoxFit.contain,
                ),
                padding: EdgeInsets.all(getProportionateScreenWidth(10)),
                decoration: BoxDecoration(
                  color: Color(0xFFF5F6F9),
                  borderRadius: BorderRadius.circular(15),
                ),
                // child: Image.asset(cart.product.images[0]),
              ),
            ),
          ),
          SizedBox(width: 10),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // SmallDropQuantFunc(options: ['1','2','3','4','5'], s1: 'Quantity', icon: Icon(Icons.add)),
              Container(
                width: MediaQuery.of(context).size.width - 200,
                child: Text(
                  cart.productName,
                  softWrap: false,
                  overflow: TextOverflow.fade,
                  style: TextStyle(color: Colors.white, fontSize: 16),
                ),
              ),
              SizedBox(height: 10),
              // SmallDropQuantFunc(options: ['1','2','3','4','5'], s1: 'Quantity', icon: Icon(Icons.add)),
              Text.rich(
                TextSpan(
                  text: "Qnt ",
                  style: TextStyle(
                      fontWeight: FontWeight.w600, color: Colors.white),
                  children: [
                    TextSpan(
                        text: " x${cart.quantity.toString()}",
                        style: Theme.of(context).textTheme.bodyText1),
                  ],
                ),
              ),
              SizedBox(height: 12.5),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  // SmallDropUpFunc(options: ['1','2','3','4','5'], s1: 'Quantity', icon: Icon(Icons.add)),
                  // SideMenuExpandedOptions(icon: Icon(Icons.add), s1: 'Quantity', options: ['1','2','3','4','5']),
                  // ProfileMenu(text: 'Quanity', icon: 'null'),
                  //             ExpansionTile(children: [
                  //               TextButton(onPressed: (){}, child: Text('1'),)
                  //
                  //               ],
                  //
                  // title: ListTile(title: Text('Quantity'))),
                  Container(
                    child: CartCheckoutDropdownButtonQuantity(
                      index: index,
                      cartItems: cartItems,
                      options: cart.countInStock >= 10
                          ? List<String>.generate(
                              10,
                              (i) {
                                int m = i + 1;
                                return m.toString();
                              },
                            )
                          : List<String>.generate(
                              cart.countInStock,
                              (i) {
                                int m = i + 1;
                                return m.toString();
                              },
                            ),
                      s1: 'Quantity',
                      dropdownValue: (cart.quantity.toString()),
                    ),
                  ),
                  SizedBox(width: 20),
                  TextButton(
                    // onPressed: ()  {
                    //   deleteItem('smk',0);
                    // },

                    onPressed: () {
                      showDialog(
                          context: context,
                          builder: (context) {
                            return AlertDialog(
                              title: Text("Delete!"),
                              content: Text(
                                  "Are you sure you want to delete this product from cart?"),
                              actions: [
                                TextButton(
                                  onPressed: () {
                                    Navigator.of(context).pop(false);
                                  },
                                  child: Text(
                                    "Cancel",
                                    style: TextStyle(color: Colors.white),
                                  ),
                                ),
                                TextButton(
                                  onPressed: () {
                                    Navigator.of(context).pop(true);
                                  },
                                  child: Text("Delete",
                                      style: TextStyle(color: Colors.red)),
                                )
                              ],
                            );
                          }).then((value) {
                        if (value) {
                          Provider.of<DeleteQuantityChangeUiUpdate>(context,
                                  listen: false)
                              .deleteItemFromCartList(index, cartItems)
                              .then((value) {
                            return showDialog(
                                context: context,
                                builder: (context) {
                                  return AlertDialog(
                                    title: Text("Success"),
                                    content: Text("Item Deleted"),
                                    actions: [
                                      TextButton(
                                        onPressed: () {
                                          Navigator.of(context).pop();
                                        },
                                        child: Text(
                                          "OK",
                                          style: TextStyle(color: Colors.white),
                                        ),
                                      ),
                                    ],
                                  );
                                });
                          }).catchError((error) {
                            return showDialog(
                                context: context,
                                builder: (context) {
                                  return AlertDialog(
                                    title: Text("Error"),
                                    content: Text(
                                        "Something went wrong, Delete Failed!"),
                                    actions: [
                                      TextButton(
                                        onPressed: () {
                                          Navigator.of(context).pop();
                                        },
                                        child: Text(
                                          "OK",
                                          style: TextStyle(color: Colors.white),
                                        ),
                                      ),
                                    ],
                                  );
                                });
                          });
                        }
                      });
                    },
                    child: Text(
                      'Delete',
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
                  //SizedBox(width: 20),
                  TextButton(
                      onPressed: () {
                        var skuidtemp = '${cart.skuId}';
                        wishlistItem(skuidtemp);
                      },
                      child: Text('Wishlist',
                          style: TextStyle(color: Colors.white))),
                ],
              ),
            ],
          )
        ],
      ),
    );
  }
}
