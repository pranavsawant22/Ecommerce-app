import 'dart:convert';

import 'package:http/http.dart' as http;

class SendOTPAPI {
  static Future<bool> sendOTPAPICall(String email) async {
    var response = await http.post(
      Uri.parse('https://auth-service-capstone.herokuapp.com/api/v1/send-otp'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(<String, String>{
      'email': email,
    }),
    );
    if (response.statusCode == 200) {
      return true;
    } else {
      return false;
    }
  }
}
