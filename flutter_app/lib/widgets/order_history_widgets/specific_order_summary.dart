// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables

import 'package:flutter/material.dart';
import '../../data_fetching_api_calls/order_history_api_call/ordered_item_details_holder.dart';

import '../../widgets/order_history_widgets/specific_order_summary_parameter_value.dart';
import 'expanded_order_view.dart';

// Widget  for Specific order summary
// containing order id, order date, price and
// an expand option for Detail view
class SpecificOrderSummary extends StatelessWidget {
  String orderId;
  int itemCount;
  int totalPrice;
  String orderStatus;
  List<OrderedItemDetailsHolder> orderItemsList;
  SpecificOrderSummary(
      {required this.orderId,
      required this.itemCount,
      required this.orderItemsList,
      required this.totalPrice,
      required this.orderStatus});
  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.secondary,
        borderRadius: BorderRadius.circular(10),
        boxShadow: [
          BoxShadow(
            blurRadius: 15,
            blurStyle: BlurStyle.outer,
            color: Colors.black,
          ),
        ],
      ),
      padding: EdgeInsets.all(20),
      child: Column(
        children: [
          SpecificOrderSummaryParameterValue(
              icon: Icon(Icons.delivery_dining),
              orderParameter: 'Order status',
              orderParameterValue: orderStatus.toLowerCase()),
          SpecificOrderSummaryParameterValue(
              icon: Icon(Icons.recent_actors),
              orderParameter: 'Order Id',
              orderParameterValue: orderId.substring(0, 5)),
          SpecificOrderSummaryParameterValue(
              icon: Icon(Icons.calendar_month),
              orderParameter: 'Total Price',
              orderParameterValue: "₹ " + totalPrice.toString()),
          SizedBox(
            height: 8,
          ),
          SpecificOrderSummaryParameterValue(
              icon: Icon(Icons.shopping_bag),
              orderParameter: 'Items',
              orderParameterValue: itemCount.toString()),
          //an expand option for Detail view of the specific order
          ExpandedOrderView(orderItemsList: orderItemsList),
        ],
      ),
    );
  }
}
