import 'dart:convert';

import 'package:e_comm_tata/utils/exception_handling/CustomException.dart';
import 'package:e_comm_tata/utils/exception_handling/user_not_log_in_exception.dart';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

import '../check_user_logged_in_api_call/check_user_logged_in.dart';

class PdpAddToCartApi extends ChangeNotifier {
  String jwtToken = '';
  String apiUrl =
      'https://auth-service-capstone.herokuapp.com/api/v1/cart/add-cart-item';

  Future<dynamic> addToCartAPICall(String skuId, int qty) async {
    var responseJson;

    if (await CheckUserLoggedInAPI.checkUserLogInAPICall() == false) {
      throw UserNotLogInException("Please Log in");
    } else {
      final sharedPreference = await SharedPreferences.getInstance();
      jwtToken = sharedPreference.getString('jwt')!;
    }

    var response = await http.post(
      Uri.parse(apiUrl),
      headers: {
        'Content-Type': 'application/json',
        'Accept': 'application/json',
        'Authorization': 'Bearer $jwtToken',
      },
      body: jsonEncode(
        <String, dynamic>{
          'sku_id': skuId,
          'quantity': qty,
        },
      ),
    );
    if (response.statusCode != 200) {
      String errorMsg = _returnResponse(response);
      throw CustomException(errorMsg);
    }
    responseJson = json.decode(response.body);

    return responseJson['success'];
  }

  dynamic _returnResponse(http.Response response) {
    switch (response.statusCode) {
      case 500:
        return 'Internal Server Error';
      case 401:
        return 'Session Expired, Please Re-login';
      case 408:
        return 'User Not Registered, Please Register';
      case 400:
        return 'Item Already Added To Cart';
      default:
        return 'No Internet connection';
    }
  }
}
