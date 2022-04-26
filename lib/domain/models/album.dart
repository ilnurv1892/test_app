import 'package:test_app/domain/models/photos.dart';

class Album {
  final int userId;
  final int id;
  final String title;
  List<Photos>? photos;

  factory Album.fromJson(Map<String, dynamic> json) => Album(
        json['userId'] as int,
        json['id'] as int,
        json['title'] as String,
        json['photos'] == null
            ? <Photos>[]
            : List<dynamic>.from(json['photos']).map((i) => Photos.fromJson(i)).toList(),
      );

  Map<String, dynamic> toJson() => <String, dynamic>{
        'userId': userId,
        'id': id,
        'title': title,
        'photos': photos,
      };

  Album copyWith(photos) {
    return Album(userId, id, title, photos);
  }

  Album(
    this.userId,
    this.id,
    this.title,
    photos,
  ) : photos = photos ?? <Photos>[];
}
