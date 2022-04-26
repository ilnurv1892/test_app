import 'package:json_annotation/json_annotation.dart';

part 'comments.g.dart';

@JsonSerializable()
class Comment {
  final int postId;
  final int id;
  final String name;
  final String email;
  final String body;

  factory Comment.fromJson(Map<String, dynamic> json) => _$CommentFromJson(json);

  Map<String, dynamic> toJson() => _$CommentToJson(this);

  Comment({required this.postId, required this.id, required this.name, required this.email, required this.body});
}
