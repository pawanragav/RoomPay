import 'dart:convert';

import 'package:bill_app/models/invoice_model.dart';
import 'package:shared_preferences/shared_preferences.dart';

class UserDb {
  static String key = "_user";

  static Future saveUserData(UserDetails ud) async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    var currentUser = jsonEncode(ud.toJson());
    pref.setString(key, currentUser);
  }

  static Future getUser() async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    String? user = pref.getString(key);
    if (user != null) {
      UserDetails ud = UserDetails.fromJson(jsonDecode(user));
      return ud;
    } else {
      return null;
    }
  }
}
