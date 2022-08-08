// ignore_for_file: prefer_const_literals_to_create_immutables, prefer_const_constructors

import 'package:e_comm_tata/data_fetching_api_calls/order_history_api_call/order_details_holder.dart';
import 'package:e_comm_tata/utils/exception_handling/CustomException.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../data_fetching_api_calls/order_history_api_call/get_all_orders_api.dart';
import '../../widgets/order_history_widgets/specific_order_summary.dart';

class OrderHistory extends StatefulWidget {
  static String routeName = "/order_history";
  const OrderHistory({Key? key}) : super(key: key);

  @override
  State<OrderHistory> createState() => _OrderHistoryState();
}

//UI for Order History Screen
class _OrderHistoryState extends State<OrderHistory> {
  bool isExpanded = false;
  @override
  Widget build(BuildContext context) {
    final getAllOrderAPIProvider =
        Provider.of<GetAllOrderAPI>(context, listen: false);
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          leading: IconButton(
            icon: Icon(
              Icons.arrow_back,
            ),
            onPressed: () {
              Navigator.pop(context);
            },
          ),
          title: Text(
            'My Orders',
            style: TextStyle(
              fontSize: 20,
              fontFamily: 'Montserrat',
            ),
          ),
          centerTitle: true,
          elevation: 0,
        ),
        body: Container(
          child: FutureBuilder(
            future: getAllOrderAPIProvider.getAllOrderAPICall(),
            builder:
                (context, AsyncSnapshot<List<OrderDetailsHolder>> snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return Center(
                  child: CircularProgressIndicator(
                    color: Colors.white,
                  ),
                );
              }

              if (snapshot.hasData == true) {
                List<int>? quantityData = snapshot.data?.map((order) {
                  int quantity = 0;
                  for (int i = 0; i < order.itemDetails.length; i++) {
                    quantity = quantity + order.itemDetails[i].quantity;
                  }
                  return quantity;
                }).toList();

                return snapshot.data!.length == 0
                    ? Center(
                        child: Text("No Orders Placed"),
                      )
                    : ListView.builder(
                        itemCount: snapshot.data!.length,
                        itemBuilder: (context, index) {
                          return Padding(
                            padding: const EdgeInsets.only(
                                right: 20, left: 20, bottom: 5, top: 10),
                            //Rectangular Widget for Specific Order Summary
                            child: SpecificOrderSummary(
                              orderStatus: snapshot.data![index].orderStatus,
                              orderId: snapshot.data![index].orderId,
                              totalPrice: snapshot.data![index].totalPrice,
                              itemCount: quantityData![index],
                              orderItemsList: snapshot.data![index].itemDetails,
                            ),
                          );
                        },
                      );
              }
              if (snapshot.hasError) {
                if (snapshot.error is CustomException) {
                  CustomException obj = snapshot.error as CustomException;
                  return Center(
                    child: Text(
                      obj.cause,
                      style: TextStyle(fontSize: 20),
                    ),
                  );
                } else {
                  return Center(
                    child: Text(
                      "Some error Occured",
                      style: TextStyle(fontSize: 20),
                    ),
                  );
                }
              } else {
                return Text("Order Something");
              }
            },
          ),
        ),
      ),
    );
  }
}
