import 'package:test_app/domain/models/comments.dart';

class Post {
  final int id;
  final int userId;
  final String title;
  final String body;
  List<Comment>? comments;

  Post copyWith(comments) {
    return Post(id, userId, title, body, comments);
  }

  Post(this.id, this.userId, this.title, this.body, comments) : comments = comments ?? <Comment>[];

  factory Post.fromJson(Map<String, dynamic> json) => Post(
        json['id'] as int,
        json['userId'] as int,
        json['title'] as String,
        json['body'] as String,
        json['comments'] == null
            ? <Comment>[]
            : List<dynamic>.from(json['comments']).map((i) => Comment.fromJson(i)).toList(),
      );

  Map<String, dynamic> toJson() => <String, dynamic>{
        'id': id,
        'userId': userId,
        'title': title,
        'body': body,
        'comments': comments,
      };
}
