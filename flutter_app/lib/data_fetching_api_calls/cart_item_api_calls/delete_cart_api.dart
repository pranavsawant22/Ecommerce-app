//
// import 'dart:convert';
// import 'dart:core';
// import 'dart:io';
// import 'package:flutter/foundation.dart';
// import 'package:http/http.dart' as http;
//
//
// class DeleteCartItemsAPI extends ChangeNotifier {
//   String jwtToken =
//       'eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJhdWQiOiJjYXBzdG9uZSBtaWNyb3NlcnZpY2VzIiwidXNlcl9pZCI6IlwiYTNkMjI1MzktNjZiNC00YWRlLWFjMTQtNGE5MTE1OGU3ZGZjXCIiLCJpc3MiOiJhdXRoX3NlcnZjZSIsImV4cCI6MTY1ODA1MDAzNywiZW1haWwiOiJzb3VtaWtzYWhhMDA3QGdtYWlsLmNvbSJ9.YpEg0LP6XUl114xVQdp1wRMO_4ET1pH73LRQFhgljiU';
//   String apiUrl =
//       'https://auth-service-capstone.herokuapp.com/api/v1/cart/delete-cart-item';
//
//   Future<bool> deleteCartItemsAPIcallStatus()
//   async {
//     try {
//       var response = await http.delete(
//         Uri.parse(apiUrl),
//         headers: {
//           'Content-Type': 'application/json',
//           'Accept': 'application/json',
//           'Authorization': 'Bearer $jwtToken',
//         },
//       );
//       if (response.statusCode != 200) {
//         return false;
//       }
//     } on SocketException {
//       print('No Internet connection');
//       return false;
//     }
//     return true;
//   }
//
//
//   static Future<String> deletecartapicall(String sku) async {
//     var responseJson;
//     String jwtToken =
//         'eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJhdWQiOiJjYXBzdG9uZSBtaWNyb3NlcnZpY2VzIiwidXNlcl9pZCI6IlwiYTNkMjI1MzktNjZiNC00YWRlLWFjMTQtNGE5MTE1OGU3ZGZjXCIiLCJpc3MiOiJhdXRoX3NlcnZjZSIsImV4cCI6MTY1ODA1MDAzNywiZW1haWwiOiJzb3VtaWtzYWhhMDA3QGdtYWlsLmNvbSJ9.YpEg0LP6XUl114xVQdp1wRMO_4ET1pH73LRQFhgljiU';
//     String apiUrl =
//         'https://auth-service-capstone.herokuapp.com/api/v1/cart/delete-cart-item';
//     try {
//       var response = await http.delete(
//         Uri.parse(apiUrl),
//         headers: {
//           'Content-Type': 'application/json',
//           'Authorization': 'Bearer $jwtToken',
//         },
//         body: sku
//       );
//       responseJson = json.decode(response.body);
//       print(responseJson);
//       var datacart = responseJson["data"];
//       List datacartitems = datacart["cart_items"];
//       var number_of_cart_items = datacartitems.length;
//       print(sku);
// // return sku;
//       // return "like";
//     }
//     on SocketException {
//       print('No Internet connection');
//     };
//     return sku;
//   }
//
//
//
//     Future<String> getAPIErrorMessage(String sku) async {
//     var responseJson;
//     try {
//       var response = await http.delete(
//         Uri.parse(apiUrl),
//         headers: {
//           'Content-Type': 'application/json',
//           'Authorization': 'Bearer $jwtToken',
//         },
//         body: {
//           'sku_id': String,
//         }
//       );
//       responseJson = _returnResponse(response);
//     } on SocketException {
//       print('No Internet connection');
//     }
//
//     return responseJson;
//   }
//   dynamic _returnResponse(http.Response response) {
//     var responseJson = json.decode(response.body.toString());
//     print(responseJson);
//     switch (response.statusCode) {
//       case 500:
//         return 'Internal Server Error';
//       case 401:
//         return 'Session Expired, Please Re-login';
//       case 408:
//         return 'User Not Registered, Please Register';
//       case 200:
//         return 'Product Quantity Updated';
//       case 400:
//         return 'Wrong Parameters';
//       default:
//         return 'No Internet connection';
//     }
//   }
// }
//

import 'dart:convert';
import 'dart:core';
import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../utils/exception_handling/CustomException.dart';
import '../check_user_logged_in_api_call/check_user_logged_in.dart';

class DeleteCartItemAPI extends ChangeNotifier {
  String jwtToken = "";

  String apiUrl =
      'https://auth-service-capstone.herokuapp.com/api/v1/cart/delete-cart-item';
  Future<bool> deleteCartAPICallStatus(String productSku) async {
    if (await CheckUserLoggedInAPI.checkUserLogInAPICall() == false) {
      throw CustomException("Please Log in");
    } else {
      final sharedPreference = await SharedPreferences.getInstance();
      jwtToken = sharedPreference.getString('jwt')!;
    }
    var responseJson;
    try {
      var response = await http.delete(
        Uri.parse(apiUrl),
        body: jsonEncode(<String, String>{"sku_id": productSku}),
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
          'Authorization': 'Bearer $jwtToken',
        },
      );
      if (response.statusCode != 200) {
        return false;
      }
    } on SocketException {
      throw CustomException("No internet Connection");
      return false;
    }
    return true;
  }

  dynamic _returnResponse(http.Response response) {
    var responseJson = json.decode(response.body.toString());
    switch (response.statusCode) {
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
