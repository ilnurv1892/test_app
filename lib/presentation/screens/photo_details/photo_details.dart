import 'package:flutter/material.dart';
import 'package:test_app/domain/models/album.dart';

class AlbumDetails extends StatelessWidget {
  const AlbumDetails(this.album, {Key? key}) : super(key: key);
  final Album album;

  static Route route(Album album) {
    return MaterialPageRoute<void>(
      builder: (_) => AlbumDetails(album),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Theme.of(context).backgroundColor,
        appBar: AppBar(
          title: Text(album.title),
        ),
        body: Scrollbar(
          child: ListView(
            children: [
              ...album.photos!.map((e) {
                return Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Column(
                    children: [
                      Image.network(e.url),
                      Text(e.title),
                    ],
                  ),
                );
              })
            ],
          ),
        ));
  }
}
