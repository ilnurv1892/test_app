import 'package:test_app/data/api/local_api.dart';
import 'package:test_app/data/api/remote_api.dart';
import 'package:test_app/domain/models/album.dart';
import 'package:test_app/domain/models/comments.dart';
import 'package:test_app/domain/models/post.dart';
import 'package:test_app/domain/models/user.dart';
import 'package:test_app/domain/repository/app_repository.dart';

class AppRepositoryImpl extends AppRepository {
  final LocalApi localApi;
  final RemoteApi remoteApi;

  AppRepositoryImpl(this.localApi, this.remoteApi);

  @override
  Future<List<User>> fetchUsers() async {
    List<User>? users = await localApi.fetchUsers();
    if (users == null) {
      users = await remoteApi.fetchUsers();
      localApi.saveUsers(users);
    }

    return users;
  }

  @override
  Future<List<Album>> fetchAlbumByUserId(int userId) async {
    List<Album>? userAlbum = await localApi.fetchAlbums(userId);
    if (userAlbum == null) {
      userAlbum = await remoteApi.fetchAlbumByUserId(userId);
      localApi.saveAlbum(userAlbum, userId);
    }

    return userAlbum;
  }

  @override
  Future<List<Post>> fetchPostByUserId(int userId) async {
    List<Post>? userPosts = await localApi.fetchPosts(userId);
    if (userPosts == null) {
      userPosts = await remoteApi.fetchPostByUserId(userId);
      localApi.savePosts(userPosts, userId);
    }

    return userPosts;
  }

  @override
  Future<void> sendComment(Comment comment, int postId) async {
    List<Comment> commentsList = await fetchCommentsByPostId(postId);
    commentsList.add(comment);
    localApi.saveComments(commentsList, postId);
    remoteApi.sendComment(comment);
  }

  @override
  Future<List<Comment>> fetchCommentsByPostId(int postId) async {
    List<Comment>? postComments = await localApi.fetchComments(postId);
    if (postComments == null) {
      postComments = await remoteApi.fetchCommentsByPostId(postId);
      localApi.saveComments(postComments, postId);
    }

    return postComments;
  }
}
