import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_sanity/flutter_sanity.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

import '../../data_fetching_api_calls/check_user_logged_in_api_call/check_user_logged_in.dart';
import '../../data_fetching_api_calls/pdp_data_fetch_api_call/pdp_rating_review_fetch_api.dart';

class PDPSanityAPI extends ChangeNotifier {
  Future<Map<String, dynamic>> pdpSanityProductDetailsApi(
      String kind, String slug, bool isPdpPage) async {
    final sanityClient = SanityClient(
      projectId: "g71nhdwa",
      dataset: "production",
    );

    var response;

    String kindAppendSKU = kind.toLowerCase() + "SKU";
    try {
      response = await sanityClient.fetch(
              '*[_type == "product" && catagory.productsku.$kind.$kindAppendSKU.slug.current == "$slug"][0]')
          as Map<String, dynamic>;
    } on SocketException catch (error) {
      rethrow;
    } on HttpException catch (error) {
      rethrow;
    } catch (error) {
      rethrow;
    }

    final productSkuData =
        response["catagory"]["productsku"][kind][kindAppendSKU];

    final countInStock = productSkuData["countInStock"];
    final itemPrice = productSkuData["price"];
    final productSkuName = productSkuData["productskuName"];
    final productSkuId = productSkuData["skuId"];
    final productSlug = productSkuData["slug"];
    final productDescription = response["description"];
    final productRating = response["rating"];

    Map<String, dynamic> pdpItemDetailMap;
    String imageUrl = "";
    var reviewsRatings;
    if (isPdpPage) {
      try {
        reviewsRatings = await PdpRatingReviewFetchApi()
            .pdpRatingReviewFetchApiCall("$kind:$slug");
      } on SocketException catch (error) {
        rethrow;
      } on HttpException catch (error) {
        rethrow;
      } catch (error) {
        rethrow;
      }
    } else {
      final option =
          '"imageUrl": catagory.productsku.$kind.$kindAppendSKU.image.asset->url';
      var response = await sanityClient.fetch(
          '*[_type == "product" && catagory.productsku.$kind.$kindAppendSKU.slug.current == "$slug"]{$option}');

      imageUrl = response[0]["imageUrl"];
    }

    bool isFavourite = false;

    if (isPdpPage) {
      if (await CheckUserLoggedInAPI.checkUserLogInAPICall() == true) {
        String jwtToken = "";
        final sharedPreference = await SharedPreferences.getInstance();
        if (sharedPreference.getString("jwt") != null) {
          jwtToken = sharedPreference.getString('jwt')!;

          var wishListResponse = await http.get(
            Uri.parse(
                'https://auth-service-capstone.herokuapp.com/api/v1/wishlist/get-wishlist'),
            headers: {
              'Content-Type': 'application/json',
              'Accept': 'application/json',
              'Authorization': 'Bearer $jwtToken',
            },
          );

          if (wishListResponse.statusCode == 200) {
            final wishListData =
                jsonDecode(wishListResponse.body) as Map<String, dynamic>;
            for (int k = 0; k < wishListData["wishlistitems"].length; k++) {
              if (wishListData["wishlistitems"][k]["sku_id"] == "$kind:$slug") {
                isFavourite = true;
                break;
              }
            }
          }
        }
      }
    }

    pdpItemDetailMap = {
      "kind": kind,
      "slug": productSlug,
      "countInStock": countInStock,
      "itemPrice": itemPrice,
      "productSkuName": productSkuName,
      "productSkuId": productSkuId,
      "productDescription": productDescription,
      "productRating": productRating,
      "ratingReviews": reviewsRatings,
      "imageUrl": imageUrl,
      "isFavourite": isFavourite,
    };

    return pdpItemDetailMap;
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
        return 'No Orders';
      default:
        return 'No Internet connection';
    }
  }
}
