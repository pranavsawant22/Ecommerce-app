import 'dart:convert';
import 'package:http/http.dart' as http;

class SearchResult {
  final String skuName;
  final String category;
  final String imageURL;

  SearchResult(
      {required this.skuName, required this.category, required this.imageURL});
}

class SearchAPI {
  static Future<Iterable<SearchResult>> fetchSearchResults(String query) async {
    var response = await http.post(
      Uri.parse('https://search-service-capstone.herokuapp.com/api/v1/search'),
      headers: {
        'Content-Type': 'application/json',
        'Accept': 'application/json',
      },
      body: jsonEncode(<String, dynamic>{
        "collection": "products",
        "q": query,
        "query_by": "productSkuName,kind,brand",
        "page": 1,
        "per_page": 250,
        "sort_by": "price:asc",
        "filter_by": ""
      }),
    );
    final responseList = jsonDecode(response.body) as Iterable;
    return responseList.map((e) => SearchResult(
        skuName: e["productSkuName"],
        category: e["kind"],
        imageURL: e["image_url"]));
  }
}
