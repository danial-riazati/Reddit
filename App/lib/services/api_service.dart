import 'dart:convert';
import 'package:dio/dio.dart';
import 'package:application/models/login_request_model.dart';
import 'package:application/models/login_response_model.dart';
import 'package:application/services/shared_service.dart';
import 'package:http/http.dart' as http;

import '../config.dart';

final Dio dio = Dio();

class APIService {
  static var client = http.Client();

  static Future<bool> login(LoginRegisterRequestModel model) async {
    Map<String, String> requestHeader = {
      'Content-Type': 'application/json; charset=UTF-8',
    };
    var url = Uri.http(Config.apiURL, Config.loginAPI);
    var response = await client.post(url,
        body: jsonEncode(model.toJson()), headers: requestHeader);
    print(response.body.toString());
    if (response.statusCode == 200) {
      //await SharedService.setLoginDetails( loginRegisterResponseModel(response.body));
      return true;
    }
    return false;
  }

  static Future<dynamic> register(LoginRegisterRequestModel model) async {
    Map<String, String> requestHeader = {
      'Content-Type': 'application/json; charset=UTF-8'
    };

    var url = Uri.http(Config.apiURL, Config.registerAPI);
    var response = await client.post(url,
        headers: requestHeader, body: jsonEncode(model.toJson()));
    if (response.statusCode == 200)
      return loginRegisterResponseModel(response.body);
    return response.body;
  }
}
