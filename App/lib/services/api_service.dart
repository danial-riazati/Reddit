import 'dart:convert';
import 'package:application/models/community_model.dart';
import 'package:application/models/post_model.dart';
import 'package:application/models/register_request_model.dart';
import 'package:application/models/request_post_model.dart';
import 'package:dio/dio.dart';
import 'package:application/models/login_request_model.dart';
import 'package:application/models/login_response_model.dart';
import 'package:application/services/shared_service.dart';
import 'package:http/http.dart' as http;

import '../config.dart';

final Dio dio = Dio();

class APIService {
  static var client = http.Client();

  static Future<bool> login(LoginRequestModel model) async {
    Map<String, String> requestHeader = {
      'Content-Type': 'application/json; charset=UTF-8',
    };
    var url = Uri.http(Config.apiURL, Config.loginAPI);
    var response = await client.post(url,
        body: jsonEncode(model.toJson()), headers: requestHeader);

    if (response.statusCode == 200) {
      SharedService.setLoginDetails(loginRegisterResponseModel(response.body));
      return true;
    }
    return false;
  }

  static Future<dynamic> register(RegisterRequestModel model) async {
    Map<String, String> requestHeader = {
      'Content-Type': 'application/json; charset=UTF-8'
    };

    var url = Uri.http(Config.apiURL, Config.registerAPI);
    var response = await client.post(url,
        headers: requestHeader, body: jsonEncode(model.toJson()));
    if (response.statusCode == 200) {
      return loginRegisterResponseModel(response.body);
    }
    return response.body;
  }

  static Future<List<PostModel>> fetchPost(String sort) async {
    Map<String, String> requestHeader = {
      'Content-Type': 'application/json; charset=UTF-8',
      'x-auth-token': SharedService.loginDetails().token!,
    };
    var url = Uri.http(Config.apiURL, Config.getPosts);
    var response = await client.get(url, headers: requestHeader);

    if (response.statusCode == 200) {
      List jsonResponse = json.decode(response.body);
      var x = jsonResponse.map((data) => PostModel.fromJson(data)).toList();
      if (sort == "Likes") {
        x.sort((a, b) {
          return -a.likes.length.compareTo(b.likes.length);
        });
      } else if (sort == "Comments") {
        x.sort((a, b) {
          return -a.comments.length.compareTo(b.comments.length);
        });
      } else {
        x.sort((a, b) {
          return -a.createdDate.compareTo(b.createdDate);
        });
      }

      return x;
    } else {
      throw Exception('Unexpected error occured!');
    }
  }

  static Future<List<CommunityModel>> fetchCommunity() async {
    Map<String, String> requestHeader = {
      'Content-Type': 'application/json; charset=UTF-8',
      'x-auth-token': SharedService.loginDetails().token!,
    };
    var url = Uri.http(Config.apiURL, Config.getCommunities);
    var response = await client.get(url, headers: requestHeader);

    if (response.statusCode == 200) {
      List jsonResponse = json.decode(response.body);

      return jsonResponse.map((data) => CommunityModel.fromJson(data)).toList();
    } else {
      throw Exception('Unexpected error occured!');
    }
  }

  static Future<dynamic> addPost(RequestPostModel model) async {
    Map<String, String> requestHeader = {
      'Content-Type': 'application/json; charset=UTF-8',
      'x-auth-token': SharedService.loginDetails().token!,
    };
    var url = Uri.http(Config.apiURL, Config.getPosts);

    var response = await client.post(url,
        headers: requestHeader, body: jsonEncode(model.toJson()));

    if (response.statusCode == 200) {
      return PostModel.fromJson(json.decode(response.body));
    }
    return response.body;
  }
}
