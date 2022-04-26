import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shimmer/shimmer.dart';
import 'package:test_app/domain/models/user.dart';
import 'package:test_app/domain/repository/app_repository.dart';
import 'package:test_app/presentation/screens/albums/albums.dart';
import 'package:test_app/presentation/screens/posts/posts.dart';
import 'package:test_app/presentation/screens/profile_page/bloc/album_preview_bloc.dart';
import 'package:test_app/presentation/screens/profile_page/bloc/post_preview_bloc.dart';
import 'package:test_app/presentation/fetch_status.dart';

class Profile extends StatelessWidget {
  const Profile(this.user, {Key? key}) : super(key: key);
  final User user;

  static Route route(User user) {
    return MaterialPageRoute<void>(
      builder: (_) => MultiBlocProvider(
        providers: [
          BlocProvider<PostPreviewBloc>(
            create: (BuildContext context) =>
                PostPreviewBloc(_.read<AppRepository>(), user.id)..add(const PostPreviewEvent()),
          ),
          BlocProvider<AlbumPreviewBloc>(
            create: (BuildContext context) =>
                AlbumPreviewBloc(_.read<AppRepository>(), user.id)..add(const AlbumPreviewEvent()),
          ),
        ],
        child: Profile(user),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Theme.of(context).backgroundColor,
        appBar: AppBar(
          title: Text(user.userName),
        ),
        body: ListView(
          children: [
            buildUserCard(user),
            buildUserPosts(),
            buildUserAlbum(),
          ],
        ));
  }

  Widget buildUserCard(User user) {
    final company = Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text("Company : ${user.company.companyName}"),
        Text("BS : ${user.company.bs}"),
        RichText(
          text: TextSpan(
              text: 'Phrase: ',
              style: const TextStyle(color: Colors.black, fontSize: 18),
              children: <TextSpan>[
                TextSpan(
                  text: '"${user.company.catchPhrase}"',
                  style: const TextStyle(fontStyle: FontStyle.italic),
                )
              ]),
        ),
      ],
    );

    final address =
        Text("Address: ${user.address.zipCode} ${user.address.city} ${user.address.street} ${user.address.suite}");

    final userInfo = Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          "Name: ${user.name}",
        ),
        Text("Email: ${user.email}"),
        Text("Phone: ${user.phone}"),
        Text("Website: ${user.website}"),
      ],
    );

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            userInfo,
            const Divider(),
            company,
            const Divider(),
            address,
          ],
        ),
      ),
    );
  }

  Widget buildUserAlbum() {
    return BlocBuilder<AlbumPreviewBloc, AlbumPreviewState>(builder: (context, state) {
      switch (state.fetchStatus) {
        case FetchStatus.initial:
          return Card(
              child: Padding(
            padding: const EdgeInsets.all(12.0),
            child: Shimmer.fromColors(
              baseColor: Colors.white,
              highlightColor: Colors.grey.shade900,
              child: Column(
                children: const [
                  Text("Albums"),
                  Divider(),
                ],
              ),
            ),
          ));

        case FetchStatus.success:
          final album = state.album;

          return InkWell(
            onTap: () => {
              HapticFeedback.lightImpact(),
              Navigator.of(context).push(AlbumScreen.route(user.id)),
            },
            child: Card(
                child: Padding(
              padding: const EdgeInsets.all(12.0),
              child: Column(
                children: [
                  const Text("Albums"),
                  const Divider(),
                  ...album.map(
                    (e) => Padding(
                      padding: const EdgeInsets.all(12.0),
                      child: Row(
                        children: [
                          SizedBox(
                            width: 50,
                            height: 50,
                            child: Image.network(e.photos!.first.thumbnailUrl),
                          ),
                          Expanded(
                            child: Padding(
                              padding: const EdgeInsets.all(12.0),
                              child: Text(
                                e.title,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            )),
          );

        case FetchStatus.failure:
          return const Center(child: Text("Cant load data"));
      }
    });
  }

  Widget buildUserPosts() {
    return BlocBuilder<PostPreviewBloc, PostPreviewState>(
      builder: (context, state) {
        switch (state.fetchStatus) {
          case FetchStatus.initial:
            return Card(
                child: Padding(
              padding: const EdgeInsets.all(12.0),
              child: Shimmer.fromColors(
                baseColor: Colors.white,
                highlightColor: Colors.grey.shade900,
                child: Column(
                  children: const [
                    Text("Posts"),
                    Divider(),
                  ],
                ),
              ),
            ));

          case FetchStatus.success:
            final posts = state.post;

            return InkWell(
                onTap: () => {
                      HapticFeedback.lightImpact(),
                      Navigator.of(context).push(PostsScreen.route(user.id)),
                    },
                child: Card(
                  child: Padding(
                    padding: const EdgeInsets.all(12.0),
                    child: Column(
                      children: [
                        const Text("Posts"),
                        ...posts.map((e) {
                          return Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Divider(),
                              Text(
                                e.title,
                                maxLines: 1,
                              ),
                              Text(
                                e.body,
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ],
                          );
                        })
                      ],
                    ),
                  ),
                ));

          case FetchStatus.failure:
            return const Center(child: Text("Cant load data"));
        }
      },
    );
  }
}
