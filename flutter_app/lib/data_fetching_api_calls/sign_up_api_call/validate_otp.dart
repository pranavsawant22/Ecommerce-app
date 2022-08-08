import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class ValidateOTPAPI {
  static Future<bool> validateOTPAPICall(String email,String otp) async {
    var response = await http.post(
      Uri.parse('https://auth-service-capstone.herokuapp.com/api/v1/validate-otp'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(<String, String>{
        'email': email,
        'otp': otp,
      }),
    );
    final responseMap = jsonDecode(response.body) as Map<String, dynamic>;
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('token', responseMap['body']);
    if (response.statusCode == 200) {
      return true;
    } else {
      return false;
    }
  }
}