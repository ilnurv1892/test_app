import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shimmer/shimmer.dart';
import 'package:test_app/domain/models/album.dart';
import 'package:test_app/domain/repository/app_repository.dart';
import 'package:test_app/presentation/screens/photo_details/photo_details.dart';
import 'package:test_app/presentation/fetch_status.dart';

import 'bloc/album_bloc.dart';

class AlbumScreen extends StatelessWidget {
  const AlbumScreen({Key? key}) : super(key: key);

  static Route route(int userId) {
    return MaterialPageRoute<void>(
      builder: (_) => BlocProvider<AlbumBloc>(
        create: (BuildContext context) => AlbumBloc(_.read<AppRepository>(), userId)..add(const AlbumEvent()),
        child: const AlbumScreen(),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Theme.of(context).backgroundColor,
        appBar: AppBar(
          title: const Text("Albums"),
        ),
        body: BlocBuilder<AlbumBloc, AlbumState>(builder: (context, state) {
          switch (state.fetchStatus) {
            case FetchStatus.initial:
              return Scrollbar(
                child: ListView.builder(
                    itemCount: 10,
                    itemBuilder: (context, position) {
                      return Card(
                        child: SizedBox(
                          height: 150,
                          child: Shimmer.fromColors(
                              period: const Duration(seconds: 2),
                              baseColor: Colors.white,
                              highlightColor: Colors.grey.shade200,
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: [
                                  const SizedBox(
                                    height: 150,
                                    width: 150,
                                    child: Placeholder(),
                                  ),
                                  Expanded(
                                    child: Container(
                                      margin: const EdgeInsets.all(8.0),
                                      decoration: const BoxDecoration(
                                        borderRadius: BorderRadius.all(Radius.circular(5.0)),
                                        color: Colors.grey,
                                      ),
                                      height: 10,
                                      width: 200,
                                    ),
                                  ),
                                ],
                              )),
                        ),
                      );
                    }),
              );

            case FetchStatus.success:
              final List<Album> albums = state.albumList;
              return Scrollbar(
                child: ListView(
                  children: [
                    ...albums.map((e) {
                      return InkWell(
                        onTap: () => {
                          HapticFeedback.lightImpact(),
                          Navigator.of(context).push(AlbumDetails.route(e)),
                        },
                        child: Card(
                          child: Row(children: [
                            SizedBox(
                              height: 150,
                              width: 150,
                              child: Image.network(e.photos!.first.thumbnailUrl),
                            ),
                            Expanded(
                                child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Text(e.title),
                            )),
                          ]),
                        ),
                      );
                    })
                  ],
                ),
              );

            case FetchStatus.failure:
              return const Center(child: Text("Cant load data"));
          }
        }));
  }
}
