import 'dart:convert';
import 'dart:io';

import 'package:e_comm_tata/data_fetching_api_calls/order_history_api_call/order_details_holder.dart';
import 'package:e_comm_tata/data_fetching_api_calls/order_history_api_call/ordered_item_details_holder.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

import '../../sanity_api_call/pdp_sainity_api/pdp_sanity_api.dart';
import '../../utils/exception_handling/CustomException.dart';
import '../check_user_logged_in_api_call/check_user_logged_in.dart';

class GetAllOrderAPI extends ChangeNotifier {
  String jwtToken = '';
  String apiUrl =
      'https://auth-service-capstone.herokuapp.com/api/v1/order/get-all-orders';

  Future<List<OrderDetailsHolder>> getAllOrderAPICall() async {
    if (await CheckUserLoggedInAPI.checkUserLogInAPICall() == false) {
      throw CustomException("Please Log in");
    } else {
      final sharedPreference = await SharedPreferences.getInstance();
      jwtToken = sharedPreference.getString('jwt')!;
    }
    var responseJson;
    try {
      var response = await http.get(
        Uri.parse(apiUrl),
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
          'Authorization': 'Bearer $jwtToken',
        },
      );
      if (response.statusCode != 200) {
        String errorMessage = _returnResponse(response.statusCode);
        throw CustomException(errorMessage);
      }
      responseJson = json.decode(response.body) as List;
    } on SocketException {
      throw CustomException("No Internet Connection");
    }

    List<OrderDetailsHolder> orderDetailsList = [];

    for (int i = 0; i < responseJson.length; i++) {
      List<OrderedItemDetailsHolder> orderItemsList = [];

      Map<String, dynamic> repeatingOrders = {};
      for (int k = 0; k < responseJson[i]["items"].length; k++) {
        String skuID = responseJson[i]["items"][k]["sku_id"];
        String ItemID = responseJson[i]["items"][k]["_id"];
        int Itemprice = responseJson[i]["items"][k]["price"];

        if (repeatingOrders[skuID] == null) {
          repeatingOrders[skuID] = {
            "quantity": 1,
            "itemId": ItemID,
            "price": Itemprice
          };
        } else {
          repeatingOrders[skuID]["quantity"] =
              (repeatingOrders[skuID]["quantity"]! + 1);
        }
      }

      await Future.forEach(repeatingOrders.keys, (String element) async {
        List<String> kindSlug = element.split(":");
        final res = await PDPSanityAPI()
            .pdpSanityProductDetailsApi(kindSlug[0], kindSlug[1], false);

        orderItemsList.add(
          OrderedItemDetailsHolder(
              quantity: repeatingOrders[element]["quantity"],
              productName: res["productSkuName"],
              imageUrl: res["imageUrl"],
              itemId: repeatingOrders[element]["itemId"],
              skuId: element,
              price: repeatingOrders[element]["price"]),
        );
      });
      orderDetailsList.add(OrderDetailsHolder(
        orderStatus: responseJson[i]["status"],
        itemDetails: orderItemsList,
        orderId: responseJson[i]["_id"],
        totalPrice: responseJson[i]["total_price"],
        userId: responseJson[i]["user_id"],
      ));
    }

    return orderDetailsList;
  }

  dynamic _returnResponse(int statusCode) {
    switch (statusCode) {
      case 500:
        return 'Internal Server Error';
      case 401:
        return 'Session Expired, Please Re-login';
      case 408:
        return 'User Not Registered, Please Register';
      case 404:
        return 'No Orders';

      default:
        return 'No Internet connection';
    }
  }
}
