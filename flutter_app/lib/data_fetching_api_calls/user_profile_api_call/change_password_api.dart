import 'dart:convert';
import 'dart:io';

import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

import '../../utils/auth/network_errors.dart';

class ChangePasswordAPI {
  static Future<dynamic> changePasswordAPICall(String oldPassword,String newPassword) async {
    final prefs = await SharedPreferences.getInstance();
    final String? jwt = prefs.getString('jwt');
    var responseJson;
    try {
      var response = await http.post(
        Uri.parse(
            'https://auth-service-capstone.herokuapp.com/api/v1/change-password'),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
          'Authorization': "Bearer $jwt",
        },
        body: jsonEncode(<String, String>{
          'oldPassword': oldPassword,
          'newPassword': newPassword,
        }),
      );
      responseJson = _returnResponse(response);
    } on SocketException {
      return FetchDataException('No Internet connection').toString();
    }
   return responseJson;
  }

  static dynamic _returnResponse(http.Response response) async {
    var responseJson = jsonDecode(response.body) as Map<String, dynamic>;
    switch (response.statusCode) {
      case 200:
        return 'success';
      case 400:
        return BadRequestException(responseJson['body']).toString();
      case 401:
        return UnauthorisedException(responseJson['body']).toString();
      case 403:
        return NotAcceptableException(responseJson['body']).toString();
      case 408:
        return RequestTimeoutException(responseJson['body'].toString());
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