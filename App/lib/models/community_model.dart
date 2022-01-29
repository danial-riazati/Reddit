class CommunityModel {
  CommunityModel({
    required this.admins,
    required this.users,
    required this.name,
  });
  late final List<dynamic> admins;
  late final List<dynamic> users;
  late final String name;

  CommunityModel.fromJson(Map<String, dynamic> json) {
    admins = List.castFrom<dynamic, dynamic>(json['admins']);
    users = List.castFrom<dynamic, dynamic>(json['users']);
    name = json['name'];
  }

  Map<String, dynamic> toJson() {
    final _data = <String, dynamic>{};
    _data['name'] = name;
    _data['admins'] = admins;
    _data['users'] = users;
    return _data;
  }
}
