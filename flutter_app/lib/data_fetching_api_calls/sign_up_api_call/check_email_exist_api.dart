import 'dart:convert';

import 'package:http/http.dart' as http;

class CheckEmailExistAPI {
  static Future<bool> checkEmailAlreadyExistAPICall(String email) async {
    var response = await http.get(
      Uri.parse(
          'https://auth-service-capstone.herokuapp.com/api/v1/check-email'),
      headers: {'email': email},
    );
    final responseDataMap = jsonDecode(response.body) as Map<String, dynamic>;

    return responseDataMap['status'];
  }
}
