// ignore_for_file: prefer_const_constructors

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../utils/cart_checkout/delete_and_quantity_change_ui_update_logic/delete_and_quantity_ui_update_logic_cart.dart';
import '../../utils/cart_checkout/models/cart_item_detail_holder.dart';

class CartCheckoutDropdownButtonAddress extends StatefulWidget {
  CartCheckoutDropdownButtonAddress(
      {required this.updateSelectedAddress,
      required this.icon,
      required this.s1,
      required this.options,
      Key? key})
      : super(key: key);
  Icon icon;
  String s1;
  List<String> options;
  Function updateSelectedAddress;
  @override
  State<CartCheckoutDropdownButtonAddress> createState() =>
      _CartCheckoutDropdownButtonAddressState();
}

class _CartCheckoutDropdownButtonAddressState
    extends State<CartCheckoutDropdownButtonAddress> {
  String dropdownValue = "";
  @override
  void initState() {
    super.initState();
    dropdownValue = widget.options[0];
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    widget.updateSelectedAddress(dropdownValue);
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(right: MediaQuery.of(context).size.width * 0.2),
      child: DropdownButton(
        isExpanded: true,
        // disabledHint: Text('Address'),
        value: dropdownValue,
        items: widget.options.map((option) {
          return DropdownMenuItem(
            value: option,
            child: Text(option.substring(0, 30)),
          );
        }).toList(),
        onChanged: (String? newValue) {
          setState(() {
            dropdownValue = newValue!;

            widget.updateSelectedAddress(dropdownValue);
          });
        },
      ),
    );
  }
}

class CartCheckoutDropdownButtonQuantity extends StatefulWidget {
  CartCheckoutDropdownButtonQuantity(
      {required this.s1,
      required this.options,
      required this.dropdownValue,
      required this.cartItems,
      required this.index,
      Key? key})
      : super(key: key);
  String s1;
  List<String> options;
  String dropdownValue;
  int index;
  List<CartItemsDetailsHolder> cartItems;

  @override
  _CartCheckoutDropdownButtonQuantityState createState() =>
      _CartCheckoutDropdownButtonQuantityState();
}

class _CartCheckoutDropdownButtonQuantityState
    extends State<CartCheckoutDropdownButtonQuantity> {
  @override
  Widget build(BuildContext context) {
    return widget.options.length == 0
        ? Center(
            child: Text(
              "Out of stock",
              style: TextStyle(color: Colors.red),
            ),
          )
        : DropdownButton(
            // style: TextStyle(color: Color(0xFF2195F2)),
            // isExpanded: true,

            value: widget.dropdownValue,
            items: widget.options.map((option) {
              return DropdownMenuItem(
                child: new Text(option),
                value: option,
              );
            }).toList(),
            onChanged: (newValue) async {
              int prevValue = int.parse(widget.dropdownValue);
              widget.dropdownValue = newValue! as String;

              int newQuantity = int.parse(widget.dropdownValue);
              try {
                await Provider.of<DeleteQuantityChangeUiUpdate>(context,
                        listen: false)
                    .quantityChangeCartItem(
                  widget.index,
                  widget.cartItems,
                  newQuantity,
                );

                widget.dropdownValue = newValue! as String;
              } catch (error) {
                widget.dropdownValue = prevValue.toString();
                showDialog(
                    context: context,
                    builder: (ctx) {
                      return AlertDialog(
                        actions: [
                          TextButton(
                              onPressed: () {
                                Navigator.of(context).pop();
                              },
                              child: Text("OK"))
                        ],
                        title: Text("Failed!"),
                        content:
                            Text("Quantity Update Failed! Please try later"),
                      );
                    });
              }
            },
          );
  }
}
