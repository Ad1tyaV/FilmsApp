import 'dart:convert';

class PostsListModel {
  final List<PostsModel> postsListsModel;

  PostsListModel({this.postsListsModel});

  factory PostsListModel.fromJson(List<dynamic> parsedJson) {
    List<PostsModel> posts = new List<PostsModel>();
    posts = parsedJson.map((i) => PostsModel.fromJson(i)).toList();
    return new PostsListModel(
      postsListsModel: posts,
    );
  }
}

class PostsModel {
  int v;
  String id;
  String name;
  String rating;

  PostsModel({this.v, this.id, this.name, this.rating});

  factory PostsModel.fromJson(Map<String, dynamic> json) {
    return PostsModel(
        v: json['__v'],
        id: json['__id'],
        name: json['name'],
        rating: json['rating']);
  }
}
