import 'dart:convert';
import 'dart:core';
import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../utils/exception_handling/CustomException.dart';
import '../check_user_logged_in_api_call/check_user_logged_in.dart';

class WishlistCartItemAPI extends ChangeNotifier {
  String jwtToken = '';
  String apiUrl =
      'https://auth-service-capstone.herokuapp.com/api/v1/wishlist/add-wishlist';
  Future<String> wishlistCartAPICallStatus(String productSku) async {
    if (await CheckUserLoggedInAPI.checkUserLogInAPICall() == false) {
      throw CustomException("Please Log in");
    } else {
      final sharedPreference = await SharedPreferences.getInstance();
      jwtToken = sharedPreference.getString('jwt')!;
    }

    var response = await http.post(
      Uri.parse(apiUrl),
      body: jsonEncode(<String, String>{"sku_id": productSku}),
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
    String responseMessage = response.body as String;

    return responseMessage;
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
        return 'Added to wishlist!';
      case 400:
        return 'Wrong Parameters';
      default:
        return 'No Internet connection';
    }
  }
}
