import 'dart:convert';
import 'dart:io';

import 'package:http/http.dart' as http;

class PdpRatingReviewFetchApi {
  Future<List<Map<String, dynamic>>> pdpRatingReviewFetchApiCall(
      String productSkuId) async {
    List<Map<String, dynamic>> rewiewRatingData;
    String apiUrl =
        'https://auth-service-capstone.herokuapp.com//api/v1/rating-review/get-rating-review-by-productid/';

    try {
      var response = await http.get(
        Uri.parse(apiUrl + productSkuId),
      );

      if (response.statusCode != 200) {
        String errorMessage = _returnResponse(response);
        throw HttpException(errorMessage);
      }
      var data;
      try {
        data = jsonDecode(response.body) as List;
      } catch (error) {
        data = [
          {
            "lastName": "empty",
            "firstName": "empty",
            "userId": "empty",
            "rating": -1,
            "comment": "empty",
            "productId": "empty",
            "_id": "empty"
          }
        ];
      }

      int i;
      rewiewRatingData = [];
      for (i = 0; i < data.length; i++) {
        rewiewRatingData.add({
          "lastName": data[i]["lastName"],
          "firstName": data[i]["firstName"],
          "userId": data[i]["userId"],
          "rating": data[i]["rating"],
          "comment": data[i]["comment"],
          "productId": data[i]["productId"],
          "_id": data[i]["_id"],
        });
      }
    } on SocketException {
      throw SocketException("Something went wrong");
    }

    return rewiewRatingData;
  }

  dynamic _returnResponse(http.Response response) {
    switch (response.statusCode) {
      case 500:
        return 'Internal Server Error';
      case 401:
        return 'Session Expired, Please Re-login';
      case 408:
        return 'User Not Registered, Please Register';
      case 404:
        return 'No reviews';

      default:
        return 'No Internet connection';
    }
  }
}
