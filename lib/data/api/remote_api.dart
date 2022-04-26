import 'dart:convert';

import 'package:test_app/constants.dart';
import 'package:test_app/domain/models/comments.dart';
import 'package:test_app/domain/models/photos.dart';
import 'package:test_app/domain/models/post.dart';
import 'package:test_app/domain/models/album.dart';
import 'package:test_app/domain/models/user.dart';
import 'package:http/http.dart' as http;

class RemoteApi {
  Future<List<User>> fetchUsers() async {
    final uri = Uri.https(ApiConstants.baseUrl, ApiConstants.users);
    final response = await http.get(uri);

    if (response.statusCode == 200) {
      List<User> _userList = List<User>.from(json.decode(response.body).map(
            (user) => User.fromJson(user),
          ));

      return _userList;
    } else {
      throw Exception('Failed to load data');
    }
  }

  Future<User> fetchUserById(int id) async {
    final uri = Uri.https(ApiConstants.baseUrl, ApiConstants.users, {'id': id.toString()});
    final response = await http.get(uri);

    if (response.statusCode == 200) {
      final user = List<User>.from(json.decode(response.body).map(
            (user) => User.fromJson(user),
          )).first;

      return user;
    } else {
      throw Exception('Failed to load data');
    }
  }

  Future<List<Album>> fetchAlbumByUserId(int id) async {
    final uri = Uri.https(ApiConstants.baseUrl, ApiConstants.albums, {'userId': id.toString()});
    final response = await http.get(uri);

    if (response.statusCode == 200) {
      final album = List<Album>.from(json.decode(response.body).map(
            (album) => Album.fromJson(album),
          ));

      final albumWithPhotos = await Future.wait(album.map((e) {
        return _loadPhotoList(e);
      }));
      return albumWithPhotos;
    } else {
      throw Exception('Failed to load data');
    }
  }

  Future<Album> _loadPhotoList(Album album) async {
    final photoList = await _fetchPhotosByAlbumId(album.id);
    return album.copyWith(photoList);
  }

  Future<List<Photos>> _fetchPhotosByAlbumId(int id) async {
    String path = "${ApiConstants.albums}/${id.toString()}/photos";
    final uri = Uri.https(ApiConstants.baseUrl, path);
    final response = await http.get(uri);

    if (response.statusCode == 200) {
      final photos = List<Photos>.from(json.decode(response.body).map(
            (photo) => Photos.fromJson(photo),
          ));

      return photos;
    } else {
      throw Exception('Failed to load data');
    }
  }

  Future<List<Post>> fetchPostByUserId(int id) async {
    final uri = Uri.https(ApiConstants.baseUrl, ApiConstants.posts, {'userId': id.toString()});
    final response = await http.get(uri);

    if (response.statusCode == 200) {
      List<Post> posts = List<Post>.from(json.decode(response.body).map(
            (posts) => Post.fromJson(posts),
          ));

      final postsWithComments = await Future.wait(posts.map((e) {
        return _loadCommentsList(e);
      }));

      return postsWithComments;
    } else {
      throw Exception('Failed to load data');
    }
  }

  Future<Post> _loadCommentsList(Post post) async {
    final commentsList = await fetchCommentsByPostId(post.id);
    return post.copyWith(commentsList);
  }

  Future<List<Comment>> fetchCommentsByPostId(int postId) async {
    String path = "${ApiConstants.posts}/${postId.toString()}${ApiConstants.comments}";
    final uri = Uri.https(ApiConstants.baseUrl, path);
    final response = await http.get(uri);
    if (response.statusCode == 200) {
      final comments = List<Comment>.from(json.decode(response.body).map(
            (comment) => Comment.fromJson(comment),
          ));
      return comments;
    } else {
      throw Exception('Failed to load data');
    }
  }

  Future<http.Response> sendComment(Comment comment) {
    final uri = Uri.https(ApiConstants.baseUrl, ApiConstants.comments);
    var response = http.post(
      uri,
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(comment.toJson()),
    );
    return response;
  }
}
