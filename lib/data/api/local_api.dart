import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';
import 'package:test_app/domain/models/album.dart';
import 'package:test_app/domain/models/comments.dart';
import 'package:test_app/domain/models/post.dart';
import 'package:test_app/domain/models/user.dart';

class LocalApi {
  Future<List<User>?>? fetchUsers() async {
    List<User> list = [];
    try {
      final _preferences = await SharedPreferences.getInstance();
      final String? users = _preferences.getString("users");

      if (users == null) {
        return null;
      }
      list = List<User>.from(json.decode(users).map((user) => User.fromJson(user)));
    } catch (ex) {
      throw Exception(ex);
    }
    return list;
  }

  Future<void> saveUsers(List<User> userList) async {
    final _preferences = await SharedPreferences.getInstance();
    final users = jsonEncode(userList.map((e) => e.toJson()).toList());
    _preferences.setString("users", users);
  }

  Future<List<Album>?>? fetchAlbums(int userId) async {
    List<Album> albumListFromPrefs = [];
    try {
      final _preferences = await SharedPreferences.getInstance();
      final String? userAlbums = _preferences.getString("albums$userId");

      if (userAlbums == null) {
        return null;
      }
      albumListFromPrefs = List<Album>.from(json.decode(userAlbums).map((album) => Album.fromJson(album)));
    } catch (ex) {
      throw Exception(ex);
    }
    return albumListFromPrefs;
  }

  Future<void> saveAlbum(List<Album> userAlbum, int userId) async {
    final _preferences = await SharedPreferences.getInstance();
    final albums = jsonEncode(userAlbum.map((e) => e.toJson()).toList());
    _preferences.setString("albums$userId", albums);
  }

  Future<List<Post>?>? fetchPosts(int userId) async {
    List<Post> postsFromPrefs = [];
    try {
      final _preferences = await SharedPreferences.getInstance();
      final String? userPosts = _preferences.getString("posts$userId");
      if (userPosts == null) {
        return null;
      }
      postsFromPrefs = List<Post>.from(json.decode(userPosts).map((posts) => Post.fromJson(posts)));
    } catch (ex) {
      throw Exception(ex);
    }
    return postsFromPrefs;
  }

  Future<void> savePosts(List<Post> userPosts, int postId) async {
    final _preferences = await SharedPreferences.getInstance();
    final posts = jsonEncode(userPosts.map((e) => e.toJson()).toList());
    _preferences.setString("posts$postId", posts);
  }

  Future<List<Comment>?>? fetchComments(postId) async {
    List<Comment> commentsList = [];
    try {
      final _preferences = await SharedPreferences.getInstance();
      final String? postComments = _preferences.getString("comments$postId");
      if (postComments == null) {
        return null;
      }
      commentsList = List<Comment>.from(json.decode(postComments).map((comment) => Comment.fromJson(comment)));
    } catch (ex) {
      throw Exception(ex);
    }
    return commentsList;
  }

  Future<void> saveComments(List<Comment> comments, int postId) async {
    final _preferences = await SharedPreferences.getInstance();
    final commentsString = jsonEncode(comments.map((e) => e.toJson()).toList());
    _preferences.setString("comments$postId", commentsString);
  }
}
