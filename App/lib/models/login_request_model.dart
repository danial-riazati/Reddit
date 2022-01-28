class LoginRegisterRequestModel {
  LoginRegisterRequestModel({
    required this.username,
    required this.password,
  });
  late final String username;
  late final String password;

  LoginRegisterRequestModel.fromJson(Map<String, dynamic> json) {
    username = json['name'];
    password = json['password'];
  }

  Map<String, dynamic> toJson() {
    final _data = <String, dynamic>{};
    _data['name'] = username;
    _data['password'] = password;
    return _data;
  }
}
