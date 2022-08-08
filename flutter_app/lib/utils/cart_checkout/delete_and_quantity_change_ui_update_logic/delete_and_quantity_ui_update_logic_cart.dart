import 'package:e_comm_tata/data_fetching_api_calls/cart_item_api_calls/update_cart_api.dart';
import 'package:e_comm_tata/utils/exception_handling/CustomException.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../data_fetching_api_calls/cart_item_api_calls/delete_cart_api.dart';
import '../../../data_fetching_api_calls/check_user_logged_in_api_call/check_user_logged_in.dart';
import '../models/cart_item_detail_holder.dart';
import 'package:http/http.dart' as http;

class DeleteQuantityChangeUiUpdate extends ChangeNotifier {
  String price = "0.0";
  List<CartItemsDetailsHolder> updatedList = [];
  void initialiseCart(List<CartItemsDetailsHolder> cartItems) {
    updatedList = cartItems;
    getPrice(updatedList, false);
  }

  List<CartItemsDetailsHolder> getUpdateCartList() {
    return updatedList;
  }

  void getPrice(List<CartItemsDetailsHolder> cartItems, bool updateUi) {
    double totalprice = 0.0;
    for (int i = 0; i < cartItems.length; i++) {
      if (cartItems[i].countInStock > 0 &&
          cartItems[i].quantity <= cartItems[i].countInStock) {
        totalprice = totalprice + (cartItems[i].price * cartItems[i].quantity);
      }
    }

    price = totalprice.toStringAsFixed(1);
    if (updateUi) {
      notifyListeners();
    }
  }

  Future<void> deleteItemFromCartList(
      int index, List<CartItemsDetailsHolder> cartItems) async {
    try {
      bool deleteStatus = await DeleteCartItemAPI()
          .deleteCartAPICallStatus(cartItems[index].skuId);

      if (deleteStatus) {
        cartItems.removeAt(index);
        updatedList = cartItems;
        getPrice(cartItems, true);
      } else {
        throw CustomException("something went wrong");
      }
    } on CustomException catch (error) {
      rethrow;
    }
  }

  Future<void> deleteAllCartItems(List<Map<String, dynamic>> cartItems) async {
    int i;
    String jwtToken = "";
    if (await CheckUserLoggedInAPI.checkUserLogInAPICall() == false) {
      throw CustomException("Please Log in");
    } else {
      final sharedPreference = await SharedPreferences.getInstance();
      jwtToken = sharedPreference.getString('jwt')!;
    }
    var response = await http.delete(
      Uri.parse(
          "https://auth-service-capstone.herokuapp.com/api/v1/cart/delete-all-cart-item"),
      headers: {
        'Content-Type': 'application/json',
        'Accept': 'application/json',
        'Authorization': 'Bearer $jwtToken',
      },
    );
    if (response.statusCode != 200) {
      throw CustomException("Some error Occured");
    }
    updatedList.clear();
    getPrice(updatedList, true);
  }

  Future<void> quantityChangeCartItem(
      int index, List<CartItemsDetailsHolder> cartItems, int quantity) async {
    try {
      var response = await UpdateCartItemAPI()
          .updateCartQuantityAPI(cartItems[index].skuId, quantity);
      cartItems[index].quantity = quantity;
      updatedList = cartItems;
      getPrice(cartItems, true);
    } on CustomException catch (error) {
      rethrow;
    }
  }
}
