import 'dart:convert';
import 'dart:io';

import 'package:e_comm_tata/data_fetching_api_calls/wishlist_api_call/wishlist_item_details_holder.dart';
import 'package:e_comm_tata/data_fetching_api_calls/wishlist_api_call/wishlist_details_holder.dart';

import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

import '../../sanity_api_call/pdp_sainity_api/pdp_sanity_api.dart';
import '../../utils/exception_handling/CustomException.dart';
import '../check_user_logged_in_api_call/check_user_logged_in.dart';

class GetWishlistAPI extends ChangeNotifier {
  String jwtToken = '';
  String apiUrl =
      'https://auth-service-capstone.herokuapp.com/api/v1/wishlist/get-wishlist';

  Future<WishlistDetailsHolder> getWishlistAPICall() async {
    var responseJson;
    if (await CheckUserLoggedInAPI.checkUserLogInAPICall() == false) {
      throw CustomException("Please Log in");
    } else {
      final sharedPreference = await SharedPreferences.getInstance();
      jwtToken = sharedPreference.getString('jwt')!;
    }

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
    responseJson = json.decode(response.body) as Map<String, dynamic>;

    List<WishlistItemDetailsHolder> wishlistItemsList = [];
    for (int j = 0; j < responseJson["wishlistitems"].length; j++) {
      String skuid = responseJson["wishlistitems"][j]['sku_id'];
      List<String> kindSlug = skuid.split(":");
      if (skuid == "SmartPhone:OP-B") {
        continue;
      }

      var res = await PDPSanityAPI()
          .pdpSanityProductDetailsApi(kindSlug[0], kindSlug[1], false);

      wishlistItemsList.add(
        WishlistItemDetailsHolder(
          id: responseJson["wishlistitems"][j]["_id"],
          skuId: responseJson["wishlistitems"][j]["sku_id"],
          imageUrl: res["imageUrl"],
          name: res["productSkuName"],
          countInStock: res["countInStock"],
          price: res["itemPrice"] * 1.0,
        ),
      );
    }
    final data = WishlistDetailsHolder(
        id: responseJson["id"],
        userid: responseJson["userid"],
        wishlistitems: wishlistItemsList);

    return data;
  }

  dynamic _returnResponse(int statusCode) {
    switch (statusCode) {
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
