import 'dart:convert';
import 'dart:io';

import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

import '../../utils/auth/network_errors.dart';

class LogOutAPI {
  static Future<dynamic> logOutAPICall() async {
    var response;
    var responseJson;
    final prefs = await SharedPreferences.getInstance();
    final String? jwt = prefs.getString('jwt');

    try {
      response = await http.post(
        Uri.parse('https://auth-service-capstone.herokuapp.com/api/v1/logout'),
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
        final prefs = await SharedPreferences.getInstance();
        final success = await prefs.remove('jwt');
        return 'success';
      case 400:
        return BadRequestException(responseJson).toString();
      case 401:
        final prefs = await SharedPreferences.getInstance();
        await prefs.remove('jwt');
        return UnauthorisedException(responseJson).toString();
      case 500:
        return InternalServerException(responseJson['body']).toString();
      default:
        return FetchDataException('StatusCode : ${response.statusCode}')
            .toString();
    }
  }
}
