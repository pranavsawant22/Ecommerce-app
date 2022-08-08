import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

import '../../utils/exception_handling/CustomException.dart';
import '../check_user_logged_in_api_call/check_user_logged_in.dart';

class DeleteWishlistItemAPI {
  static Future<void> deleteWishlistItemAPICall(String sku_id) async {
    String jwtToken = "";
    if (await CheckUserLoggedInAPI.checkUserLogInAPICall() == false) {
      throw CustomException("Please Log in");
    } else {
      final sharedPreference = await SharedPreferences.getInstance();
      jwtToken = sharedPreference.getString('jwt')!;
    }

    var response = await http.put(
      Uri.parse(
          "https://auth-service-capstone.herokuapp.com/api/v1/wishlist/remove-item-from-wishlist"),
      headers: {
        'Content-Type': 'application/json',
        'Accept': 'application/json',
        'Authorization': 'Bearer $jwtToken',
      },
      body: jsonEncode(
        <String, String>{"sku_id": sku_id},
      ),
    );
    if (response.statusCode != 200) {
      throw CustomException("Some error Occured");
    }
  }
}
