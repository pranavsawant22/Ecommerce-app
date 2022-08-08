import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import '../../data_fetching_api_calls/check_user_logged_in_api_call/check_user_logged_in.dart';
import '../../data_fetching_api_calls/wishlist_api_call/wishlist_item_details_holder.dart';
import '../exception_handling/CustomException.dart';

class WishListDelete extends ChangeNotifier {
  List<WishlistItemDetailsHolder> wishList = [];
  void initialiseWishList(List<WishlistItemDetailsHolder> loadedWishList) {
    wishList = loadedWishList;
  }

  List<WishlistItemDetailsHolder> getUpdateWishList() {
    return wishList;
  }

  Future<void> deleteWishList(
      int index, List<WishlistItemDetailsHolder> loadedWishList) async {
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
        <String, String>{"sku_id": loadedWishList[index].skuId},
      ),
    );
    if (response.statusCode != 200) {
      throw CustomException("Some error Occured");
    }

    loadedWishList.removeAt(index);
    wishList = loadedWishList;
    notifyListeners();
  }
}
