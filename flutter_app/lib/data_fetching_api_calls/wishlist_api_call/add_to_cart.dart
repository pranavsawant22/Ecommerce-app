import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

import '../../utils/exception_handling/CustomException.dart';
import '../check_user_logged_in_api_call/check_user_logged_in.dart';

class addToCartAPI {
  static Future<bool> addToCartAPICall(String sku_id, int quantity) async {
    String jwtToken = "";
    if (await CheckUserLoggedInAPI.checkUserLogInAPICall() == false) {
      throw CustomException("Please Log in");
    } else {
      final sharedPreference = await SharedPreferences.getInstance();
      jwtToken = sharedPreference.getString('jwt')!;
    }
    var response = await http.post(
      Uri.parse(
          'https://auth-service-capstone.herokuapp.com/api/v1/cart/add-cart-item'),
      body:
          jsonEncode(<String, dynamic>{"sku_id": sku_id, "quantity": quantity}),
    );

    if (response.statusCode == 200) {
      return true;
    } else {
      return false;
    }
  }
}

// dynamic _returnResponse(http.Response response) {
//   switch (response.statusCode) {
//     case 200:
//       var responseJson = json.decode(response.body.toString());
//       print(responseJson);
//       return responseJson;
//     case 400:
//       throw BadRequestException(response.body.toString());
//     case 401:
//     case 403:
//       throw UnauthorisedException(response.body.toString());
//     case 500:
//     default:
//       throw FetchDataException(
//           'Error occured while Communication with Server with StatusCode : ${response.statusCode}');
//   }
//
// }
