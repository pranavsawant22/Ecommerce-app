import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class UpdatePasswordAPI {
  static Future<bool?> updatePasswordAPICall(String email,String password) async {
    final prefs = await SharedPreferences.getInstance();
    var response = await http.post(
      Uri.parse('https://auth-service-capstone.herokuapp.com/api/v1/update-password'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
        'email_id': email,
        'randomToken': prefs.getString('token')!,
      },
      body: jsonEncode(<String, String>{
        'newPassword': password,
      }),
    );
    final responseMap = jsonDecode(response.body) as Map<String, dynamic>;
    if (response.statusCode == 200) {
      return true;
    }
    else if(response.statusCode == 400){
      return null;
    }
    else {
      return false;
    }
  }
}