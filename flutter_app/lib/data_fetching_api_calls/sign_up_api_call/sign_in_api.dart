import 'dart:convert';
import 'dart:io';

import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

import '../../utils/auth/network_errors.dart';

class SignInAPI {
  static Future<dynamic> signInAPICall(String email, String password) async {
    var response;
    var responseJson;
    try{
    response = await http.post(
      Uri.parse('https://auth-service-capstone.herokuapp.com/api/v1/login'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
        'typeOfLogin': 'APP',
      },
      body: jsonEncode(<String, String>{
        'email': email,
        'password': password,
      }),
    );
    responseJson = _returnResponse(response);
    } on SocketException {
      return FetchDataException('No Internet connection');
    }
    return responseJson;
  }

  static dynamic _returnResponse(http.Response response) async {
    var responseJson = jsonDecode(response.body) as Map<String, dynamic>;
    switch (response.statusCode) {
      case 200:
        final prefs = await SharedPreferences.getInstance();
        await prefs.setString('jwt', responseJson['body']);
        return 'success';
      case 400:
        return BadRequestException(responseJson['body']).toString();
      case 403:
        return NotAcceptableException(responseJson['body']).toString();
      case 409:
        return ConflictException(responseJson['body']).toString();
      case 500:
        return InternalServerException(responseJson['body']).toString();
      default:
        return FetchDataException(
            'StatusCode : ${response.statusCode}').toString();
    }
  }
}
