import 'package:test_app/domain/models/album.dart';
import 'package:test_app/domain/models/comments.dart';
import 'package:test_app/domain/models/post.dart';
import 'package:test_app/domain/models/user.dart';

abstract class AppRepository {
  Future<List<User>> fetchUsers();
  Future<List<Album>> fetchAlbumByUserId(int userId);
  Future<List<Post>> fetchPostByUserId(int userId);
  Future<void> sendComment(Comment comment, int postId);
  Future<List<Comment>> fetchCommentsByPostId(int postId);
}
