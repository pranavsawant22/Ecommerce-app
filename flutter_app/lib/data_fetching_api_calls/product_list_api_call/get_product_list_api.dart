import 'dart:convert';
import 'package:e_comm_tata/data_fetching_api_calls/product_list_api_call/product_list.dart';
import 'package:e_comm_tata/data_fetching_api_calls/product_list_api_call/typesense_data_holder_model.dart';
import 'package:e_comm_tata/utils/exception_handling/CustomException.dart';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;

class GetProductListAPI extends ChangeNotifier {
  Future<List<TypeSenseDataHolderModel>> fetchProductList(
      String kind, String parameter, String ascendingOrDescending) async {
    var response = await http.post(
      Uri.parse('https://auth-service-capstone.herokuapp.com/api/v1/search'),
      headers: {
        'Content-Type': 'application/json',
        'Accept': 'application/json',
      },
      body: jsonEncode(<String, dynamic>{
        "collection": "products",
        "q": kind,
        "query_by": "productSkuName,kind,brand",
        "page": 1,
        "per_page": 250,
        "sort_by": "$parameter:$ascendingOrDescending",
        "filter_by": ""
      }),
    );

    if (response.statusCode != 200) {
      String errorMessage = _returnResponse(response.statusCode);
      throw CustomException(errorMessage);
    }
    final data = jsonDecode(response.body) as List;
    List<TypeSenseDataHolderModel> typesenseData = [];
    int i;
    for (i = 0; i < data.length; i++) {
      typesenseData.add(TypeSenseDataHolderModel(
          name: data[i]["name"],
          rating: data[i]["rating"],
          price: data[i]["price"],
          description: data[i]["description"],
          brand: data[i]["brand"],
          gender: data[i]["gender"],
          imageUrl: data[i]["image_url"],
          kind: data[i]["kind"],
          productSkuName: data[i]["productSkuName"],
          slug: data[i]["slug"]));
    }

    return typesenseData;
  }

  dynamic _returnResponse(int code) {
    switch (code) {
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
