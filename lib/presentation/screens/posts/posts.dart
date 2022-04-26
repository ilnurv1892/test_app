import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shimmer/shimmer.dart';
import 'package:test_app/domain/models/post.dart';
import 'package:test_app/domain/repository/app_repository.dart';
import 'package:test_app/presentation/screens/posts/bloc/posts_bloc.dart';
import 'package:test_app/presentation/screens/posts_details/posts_details.dart';
import 'package:test_app/presentation/fetch_status.dart';

class PostsScreen extends StatelessWidget {
  const PostsScreen({Key? key}) : super(key: key);

  static Route route(int userId) {
    return MaterialPageRoute<void>(
      builder: (_) => BlocProvider<PostsBloc>(
        create: (BuildContext context) => PostsBloc(_.read<AppRepository>(), userId)..add(const PostEvent()),
        child: const PostsScreen(),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Theme.of(context).backgroundColor,
        appBar: AppBar(
          title: const Text("Posts"),
        ),
        body: BlocBuilder<PostsBloc, PostsState>(builder: (context, state) {
          final size = MediaQuery.of(context).size;
          switch (state.fetchStatus) {
            case FetchStatus.initial:
              return SizedBox(
                height: size.height,
                child: ListView.builder(
                    itemCount: 10,
                    itemBuilder: (context, position) {
                      return Card(
                        child: Container(
                          height: 60,
                          margin: const EdgeInsets.all(12),
                          child: Shimmer.fromColors(
                              period: const Duration(seconds: 2),
                              baseColor: Colors.white,
                              highlightColor: Colors.grey.shade200,
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Container(
                                    decoration: const BoxDecoration(
                                      borderRadius: BorderRadius.all(Radius.circular(5.0)),
                                      color: Colors.grey,
                                    ),
                                    height: 10,
                                    width: size.width / 2,
                                  ),
                                  const Divider(),
                                  const SizedBox(
                                    height: 15,
                                  ),
                                  Container(
                                    decoration: const BoxDecoration(
                                      borderRadius: BorderRadius.all(Radius.circular(5.0)),
                                      color: Colors.grey,
                                    ),
                                    height: 10,
                                    width: size.width,
                                  ),
                                ],
                              )),
                        ),
                      );
                    }),
              );
            case FetchStatus.success:
              final List<Post> posts = state.postsList;
              return ListView(
                children: [
                  ...posts.map((post) {
                    return InkWell(
                      onTap: () => {
                        HapticFeedback.lightImpact(),
                        Navigator.of(context).push(PostDetails.route(post)),
                      },
                      child: Card(
                        child: Container(
                          height: 60,
                          margin: const EdgeInsets.all(12),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                post.title,
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                              ),
                              const Divider(),
                              Text(
                                post.body,
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ],
                          ),
                        ),
                      ),
                    );
                  }),
                ],
              );
            case FetchStatus.failure:
              return const Center(
                child: Text("Cant load data"),
              );
          }
        }));
  }
}
