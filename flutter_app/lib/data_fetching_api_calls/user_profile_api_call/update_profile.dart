import 'dart:convert';
import 'dart:io';

import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

import '../../utils/auth/network_errors.dart';

class UpdateProfileAPI {
  static Future<dynamic> updateProfileAPICall(String firstName, String lastName, String phone) async {
    var response;
    var responseJson;
    final prefs = await SharedPreferences.getInstance();
    final String? jwt = prefs.getString('jwt');
    try{
      response = await http.patch(
        Uri.parse('https://auth-service-capstone.herokuapp.com/api/v1/user/profile'),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
          'Authorization': 'Bearer $jwt'
        },
        body: jsonEncode(<String, String>{
          'firstName': firstName,
          'lastName': lastName,
          'phone': phone
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
