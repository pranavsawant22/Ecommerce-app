// ignore_for_file: prefer_const_declarations
//this file is unused in the code but keeping it for
//future order management implementation
import 'dart:convert';
import 'dart:io';

import 'package:flutter_sanity/flutter_sanity.dart';
import 'package:http/http.dart' as http;

class InventoryUpdate {
  static Future<void> inventoryUpdate(
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

    // "mutations": [
    // {
    // "patch": {
    // "id": "person-1234",
    // "set": {
    // "name": "Remington Steele"
    // }
    // }
    // }];
    final mutation = {
      "mutation": [
        {
          'patch': {
            'id': response["_id"],
            'set': {
              'countInStock': "20",
            }
          }
        }
      ]
    };

    var response2 = await http.post(
      Uri.parse(
          "https://g71nhdwa.api.sanity.io/v2021-06-07/data/mutate/production"),
      headers: {
        "Content-Type": "application/json",
        "Authorization":
            "Bearer skU1NcsxuEg4257BGL7GSKIBBVyGohw9MR5XdrNj6pOs3t0C6CUvCCtrqR1Wl5xk8vXezYmwYvsFufR62",
      },
      body: jsonEncode(mutation),
    );

    final productSkuData =
        response["catagory"]["productsku"][kind][kindAppendSKU];

    final countInStock = productSkuData["countInStock"];
    final itemPrice = productSkuData["price"];
    final productSkuName = productSkuData["productskuName"];
    final productSkuId = productSkuData["skuId"];
    final productSlug = productSkuData["slug"];
    final productDescription = response["description"];
    final productRating = response["rating"];
  }
}
