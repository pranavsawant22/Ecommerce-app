import 'dart:convert';
import 'dart:io';

import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

import '../../utils/auth/network_errors.dart';

class AddAddressAPI {
  static Future<dynamic> addAddressAPICall(String name, String buildingInfo,
      String state, String city, String landmark, String pincode) async {
    var response;
    var responseJson;
    final prefs = await SharedPreferences.getInstance();
    final jwt = prefs.getString('jwt');

    try {
      response = await http.post(
        Uri.parse(
            'https://auth-service-capstone.herokuapp.com/api/v1/user/address'),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
          'Authorization': 'Bearer $jwt',
        },
        body: jsonEncode(<String, String>{
          "name": name,
          "buildingInfo": buildingInfo,
          "state": state,
          "city": city,
          "landmark": landmark,
          "pincode": pincode
        }),
      );
      responseJson = _returnResponse(response);
    } on SocketException {
      return FetchDataException('No Internet connection');
    }
    return responseJson;
  }

  static dynamic _returnResponse(http.Response response) async {
    var responseJson = jsonDecode(response.body);
    switch (response.statusCode) {
      case 201:
        return 'success';
      case 400:
        return BadRequestException(responseJson).toString();
      case 403:
        return NotAcceptableException(responseJson).toString();
      case 409:
        return ConflictException(responseJson).toString();
      case 500:
        return InternalServerException(responseJson).toString();
      default:
        return FetchDataException('StatusCode : ${response.statusCode}')
            .toString();
    }
  }
}
