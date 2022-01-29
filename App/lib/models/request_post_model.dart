class RequestPostModel {
  RequestPostModel({
    required this.communityName,
    required this.text,
  });
  late final String communityName;
  late final String text;
  late final String createdDate;

  RequestPostModel.fromJson(Map<String, dynamic> json) {
    communityName = json['community_name'];
    text = json['text'];
    createdDate = json['created_date'];
  }

  Map<String, dynamic> toJson() {
    final _data = <String, dynamic>{};
    _data['community_name'] = communityName;
    _data['text'] = text;
    _data['created_date'] = DateTime.now().toString();
    return _data;
  }
}
