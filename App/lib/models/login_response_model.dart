import 'dart:convert';

LoginRegisterResponseModel loginRegisterResponseModel(str) =>
    LoginRegisterResponseModel.fromJson(json.decode(str));

class LoginRegisterResponseModel {
  LoginRegisterResponseModel({
    required this.username,
    required this.token,
    required this.id,
  });
  late final String id;
  late final String username;
  late final String token;

  LoginRegisterResponseModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    username = json['name'];
    token = json['token'];
  }

  Map<String, dynamic> toJson() {
    final _data = <String, dynamic>{};
    _data['id'] = id;
    _data['name'] = username;
    _data['token'] = token;
    return _data;
  }
}
