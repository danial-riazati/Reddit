class PostModel {
  PostModel({
    required this.likes,
    required this.dislikes,
    required this.comments,
    required this.communityName,
    required this.text,
    required this.publisherName,
    required this.communityId,
    required this.publisherId,
    required this.createdDate,
  });
  late final List<dynamic> likes;
  late final List<dynamic> dislikes;
  late final List<dynamic> comments;
  late final String communityName;
  late final String text;
  late final String publisherName;
  late final String communityId;
  late final String publisherId;
  late final String createdDate;

  PostModel.fromJson(Map<String, dynamic> json) {
    likes = List.castFrom<dynamic, dynamic>(json['likes']);
    dislikes = List.castFrom<dynamic, dynamic>(json['dislikes']);
    comments = List.castFrom<dynamic, dynamic>(json['comments']);
    communityName = json['community_name'];
    publisherName = json['publisher_name'];
    text = json['text'];
    communityId = json['community_id'];
    publisherId = json['publisher_id'];
    createdDate = json['created_date'];
  }

  Map<String, dynamic> toJson() {
    final _data = <String, dynamic>{};
    _data['likes'] = likes;
    _data['dislikes'] = dislikes;
    _data['comments'] = comments;
    _data['community_name'] = communityName;
    _data['publisher_name'] = publisherName;
    _data['text'] = text;
    _data['community_id'] = communityId;
    _data['publisher_id'] = publisherId;
    _data['created_date'] = createdDate;
    return _data;
  }
}
