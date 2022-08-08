import 'dart:convert';
import 'dart:io';
import 'package:e_comm_tata/sanity_api_call/pdp_sainity_api/pdp_sanity_api.dart';
import 'package:e_comm_tata/utils/exception_handling/cart_empty_exception.dart';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import '../../utils/cart_checkout/models/cart_item_detail_holder.dart';
import '../../utils/cart_checkout/models/cart_item_holder.dart';
import '../../utils/exception_handling/CustomException.dart';
import '../check_user_logged_in_api_call/check_user_logged_in.dart';

class GetCartItemsAPI extends ChangeNotifier {
  String jwtToken = '';
  String apiUrl = 'https://auth-service-capstone.herokuapp.com/api/v1/cart';

  Future<CartDetailsHolder?> getcartapicall() async {
    var responseJson;
    String jwtToken = "";

    if (await CheckUserLoggedInAPI.checkUserLogInAPICall() == false) {
      throw CustomException("Please Log in");
    } else {
      final sharedPreference = await SharedPreferences.getInstance();
      jwtToken = sharedPreference.getString('jwt')!;
    }

    String apiUrl = 'https://auth-service-capstone.herokuapp.com/api/v1/cart';
    CartDetailsHolder object1;
    try {
      var response = await http.get(
        Uri.parse(apiUrl),
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
          'Authorization': 'Bearer $jwtToken',
        },
      );
      if (response.statusCode != 200) {
        String errorMessgae = _returnResponse(response);
        throw CustomException(errorMessgae);
      }

      responseJson = json.decode(response.body) as Map<String, dynamic>;

      if (responseJson["success"] == false) {
        throw CartEmptyException("Cart is empty");
      }

      var datacart = responseJson["data"];
      List datacartitems = datacart["cart_items"];
      var number_of_cart_items = datacartitems.length;
      List<CartItemsDetailsHolder> items = [];

      for (int i = 0; i < number_of_cart_items; i++) {
        String skuid = datacartitems[i]['sku_id'];
        List<String> kindSlug = skuid.split(":");

        var res = await PDPSanityAPI()
            .pdpSanityProductDetailsApi(kindSlug[0], kindSlug[1], false);

        CartItemsDetailsHolder object = CartItemsDetailsHolder(
            countInStock: res["countInStock"],
            price: res["itemPrice"] * 1.0,
            productName: res["productSkuName"],
            imageUrl: res["imageUrl"],
            cartitemId: datacartitems[i]['cart_item_id'],
            quantity: datacartitems[i]['quantity'],
            skuId: datacartitems[i]['sku_id']);
        items.add(object);
      }
      ;

      object1 = CartDetailsHolder(
          Id: datacart["_id"], itemDetails: items, userId: datacart["user_id"]);

      return object1;
    } on SocketException {
      throw CustomException("No internet Connection");
    }
  }

  dynamic _returnResponse(http.Response response) {
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
