import 'dart:convert';
import 'dart:io';

import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

import '../../utils/auth/network_errors.dart';

class RegisterAPI {
  static Future<dynamic> registerAPICall(
      String fName, String lName, String phone) async {
    final prefs = await SharedPreferences.getInstance();
    var responseJson;
    var response;
    try {
      response = await http.post(
        Uri.parse(
            'https://auth-service-capstone.herokuapp.com/api/v1/register'),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
          'randomToken': prefs.getString('token')!,
        },
        body: jsonEncode(<String, String>{
          "firstName": fName,
          "lastName": lName,
          "email": prefs.getString('email_register')!,
          "password": prefs.getString('password_register')!,
          "phone": phone,
        }),
      );
      responseJson = _returnResponse(response);
    } on SocketException {
      return FetchDataException('No Internet connection').toString();
    }
    return responseJson;
  }

  static dynamic _returnResponse(http.Response response) {
    var responseJson = jsonDecode(response.body) as Map<String, dynamic>;
    switch (response.statusCode) {
      case 201:
        return 'success';
      case 400:
        return BadRequestException(responseJson['body']).toString();
      case 401:
        return UnauthorisedException(responseJson['body']).toString();
      case 406:
        return NotAcceptableException(responseJson['body']).toString();
      case 408:
        return UnauthorisedException(responseJson['body']).toString();
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
