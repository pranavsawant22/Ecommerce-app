// ignore_for_file: prefer_const_constructors

import '../../data_fetching_api_calls/order_history_api_call/ordered_item_details_holder.dart';
import '../../widgets/order_history_widgets/review_window.dart';
import 'package:flutter/material.dart';

//UI for Expanded Order Detail view
//Contains Item pic, item name, price, quantity
//Also Add/Edit review Button
class ExpandedOrderView extends StatelessWidget {
  List<OrderedItemDetailsHolder> orderItemsList;
  ExpandedOrderView({required this.orderItemsList});

  //A function for toggling Add/Edit review Button
  //Used a ModalBottomSheet
  openReviewWindow(
      {required BuildContext ctx,
      required String itemSkuId,
      required String image,
      required String name,
      required int price}) {
    showModalBottomSheet<void>(
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      enableDrag: false,
      isDismissible: false,
      context: ctx,
      builder: (BuildContext context) {
        return ReviewWindow(
            context: context,
            itemSkuId: itemSkuId,
            image: image,
            name: name,
            price: price);
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return ExpansionTile(
      title: Text(
        'Expand',
        style: TextStyle(color: Colors.white),
      ),
      textColor: Colors.black26,
      children: orderItemsList.map((orderItem) {
        return Column(
          children: [
            ListTile(
              leading: Image.network(orderItem.imageUrl),
              title: Text(
                orderItem.productName,
                style: TextStyle(fontSize: 23),
              ),
              subtitle: Text(
                'Qty: ${orderItem.quantity}',
                style: TextStyle(fontSize: 18),
              ),
              trailing: Text(
                "₹ " + orderItem.price.toString(),
                style: TextStyle(fontSize: 20),
              ),
            ),
            MaterialButton(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
              onPressed: () {
                openReviewWindow(
                    ctx: context,
                    itemSkuId: orderItem.skuId,
                    image: orderItem.imageUrl,
                    name: orderItem.productName,
                    price: orderItem.price);
              },
              color: Theme.of(context).colorScheme.tertiary,
              minWidth: double.infinity,
              child: Text(
                'Add Review',
                style: TextStyle(fontSize: 18),
                textAlign: TextAlign.left,
              ),
            )
          ],
        );
      }).toList(),
    );
  }
}
