// import 'dart:html';

import 'package:shared_preferences/shared_preferences.dart';

class CheckUserLoggedInAPI {
  static Future<bool> checkUserLogInAPICall() async {
    final prefs = await SharedPreferences.getInstance();

    final jwt = prefs.getString('jwt');

    if (jwt != null) {
      return true;
    }
    return false;
  }
}
