import 'package:json_annotation/json_annotation.dart';

part 'photos.g.dart';

@JsonSerializable()
class Photos {
  final int albumId;
  final int id;
  final String title;
  final String url;
  final String thumbnailUrl;

  factory Photos.fromJson(Map<String, dynamic> json) => _$PhotosFromJson(json);

  Map<String, dynamic> toJson() => _$PhotosToJson(this);

  Photos(this.albumId, this.id, this.title, this.url, this.thumbnailUrl);
}
