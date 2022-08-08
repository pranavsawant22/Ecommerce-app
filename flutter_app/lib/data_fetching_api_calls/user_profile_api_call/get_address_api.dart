import 'dart:convert';
import 'dart:io';

import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

import '../../utils/auth/network_errors.dart';

class GetAddressAPI {
  static Future<dynamic> getAddressAPICall() async {
    var response;
    var responseJson;
    final prefs = await SharedPreferences.getInstance();
    final String? jwt = prefs.getString('jwt');
    try{
      response = await http.get(
        Uri.parse('https://auth-service-capstone.herokuapp.com/api/v1/user/address'),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
          'Authorization': 'Bearer $jwt',
        },
      );
      responseJson = _returnResponse(response);
    } on SocketException {
      throw FetchDataException('No Internet connection');
    }
    return responseJson;
  }

  static dynamic _returnResponse(http.Response response) async {
    var responseJson = jsonDecode(response.body);
    switch (response.statusCode) {
      case 200:
        return responseJson["addresses"]["addresses"];
      case 400:
        throw BadRequestException(responseJson).toString();
      case 401:
        throw UnauthorisedException(responseJson.toString());
      case 403:
        throw NotAcceptableException(responseJson).toString();
      case 408:
        throw RequestTimeoutException(responseJson).toString();
      case 500:
        throw InternalServerException(responseJson).toString();
      default:
        throw FetchDataException(
            'StatusCode : ${response.statusCode}').toString();
    }
  }
}
