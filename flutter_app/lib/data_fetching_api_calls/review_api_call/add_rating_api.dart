import 'dart:convert';
import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

import '../../utils/exception_handling/CustomException.dart';
import '../check_user_logged_in_api_call/check_user_logged_in.dart';

class AddRatingAPI extends ChangeNotifier {
  String jwtToken = '';

  Future<bool> addRatingAPICall(
      String productId, double rating, String skuid) async {
    String? lastName = "";
    String? firstName = "";
    if (await CheckUserLoggedInAPI.checkUserLogInAPICall() == false) {
      throw CustomException("Please Log in");
    } else {
      final sharedPreference = await SharedPreferences.getInstance();
      jwtToken = sharedPreference.getString('jwt')!;
      lastName = sharedPreference.getString('lastName');
      firstName = sharedPreference.getString('firstName');
    }

    try {
      var response = await http.post(
          Uri.parse(
              'https://auth-service-capstone.herokuapp.com/api/v1/rating-review/add-or-update-rating'),
          headers: {
            'Content-Type': 'application/json',
            'Accept': 'application/json',
            'Authorization': 'Bearer $jwtToken',
          },
          body: jsonEncode(<String, dynamic>{
            "productId": productId,
            "rating": rating.round(),
            "skuId": skuid,
            "lastName": lastName,
            "firstName": firstName,
          }));

      if (response.statusCode != 200) {
        String errorMessage = _returnResponse(response);

        throw Exception(errorMessage);
      }
    } on SocketException {
      throw Exception('No internet connection');
    }

    return true;
  }

  dynamic _returnResponse(http.Response response) {
    switch (response.statusCode) {
      case 500:
        return 'Internal Server Error';
      case 401:
        return 'Session Expired, Please Re-login';
      case 408:
        return 'User Not Registered, Please Register';
      default:
        return 'No Internet connection';
    }
  }
}
