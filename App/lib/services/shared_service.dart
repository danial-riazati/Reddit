import 'package:application/models/login_response_model.dart';
import 'package:application/models/user.dart';
import 'package:flutter/material.dart';

class SharedService {
  static final user = User();
  static bool isLoggedIn() {
    return user.token == null;
  }

  static User loginDetails() {
    return user;
  }

  static void setLoginDetails(LoginRegisterResponseModel model) {
    user.id = model.id;
    user.token = model.token;
    user.username = model.username;
  }

  static Future<void> logout(BuildContext context) async {
    user.id = null;
    user.username = null;
    user.token = null;
    Navigator.pushNamedAndRemoveUntil(context, '/login', (route) => false);
  }
}
