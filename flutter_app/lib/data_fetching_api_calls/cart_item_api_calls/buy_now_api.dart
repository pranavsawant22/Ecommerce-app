import 'dart:convert';
import 'dart:core';
import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../utils/cart_checkout/models/cart_item_detail_holder.dart';
import '../../utils/exception_handling/CustomException.dart';
import '../check_user_logged_in_api_call/check_user_logged_in.dart';

class BuyNowCartItemAPI extends ChangeNotifier {
  String jwtToken = '';
  String apiUrl =
      'https://auth-service-capstone.herokuapp.com/api/v1/order/add-order';
  Future<bool> buyNowCartAPICall(Map<String, dynamic> placeOrderBody,
      List<CartItemsDetailsHolder> cartItemsList) async {
    if (await CheckUserLoggedInAPI.checkUserLogInAPICall() == false) {
      throw CustomException("Please Log in");
    } else {
      final sharedPreference = await SharedPreferences.getInstance();
      jwtToken = sharedPreference.getString('jwt')!;
    }

    try {
      var response = await http.post(
        Uri.parse(apiUrl),
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
          'Authorization': 'Bearer $jwtToken',
        },
        body: jsonEncode(placeOrderBody),
      );
      if (response.statusCode != 200) {
        String errorMessage = _returnResponse(response.statusCode);
        throw CustomException(errorMessage);
      }
    } on SocketException {
      throw CustomException("No internet");
      return false;
    }
    return true;
  }

  dynamic _returnResponse(int statusCode) {
    switch (statusCode) {
      case 500:
        return 'Internal Server Error';
      case 401:
        return 'Session Expired, Please Re-login';
      case 408:
        return 'User Not Registered, Please Register';
      case 200:
        return 'Product Quantity Updated';
      case 400:
        return 'Wrong Parameters';
      default:
        return 'No Internet connection';
    }
  }
}
