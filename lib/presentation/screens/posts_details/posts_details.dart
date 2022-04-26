import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:test_app/domain/models/post.dart';
import 'package:test_app/domain/repository/app_repository.dart';
import 'package:test_app/presentation/fetch_status.dart';
import 'package:test_app/presentation/screens/posts_details/bloc/send_comment_bloc.dart';

class PostDetails extends StatelessWidget {
  const PostDetails(this.post, {Key? key}) : super(key: key);
  final Post post;

  static Route route(Post post) {
    return MaterialPageRoute<void>(
      builder: (_) => BlocProvider<CommentsBloc>(
        create: (BuildContext context) => CommentsBloc(_.read<AppRepository>(), post)..add(CommentsFetched()),
        child: PostDetails(post),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Theme.of(context).backgroundColor,
        resizeToAvoidBottomInset: true,
        appBar: AppBar(
          title: Text(post.title),
        ),
        floatingActionButton: FloatingActionButton(
            child: const Icon(Icons.add),
            onPressed: () async {
              WidgetsBinding.instance?.addPostFrameCallback((_) => _addCommentDialog(context));
            }),
        body: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.max,
            children: [
              SizedBox(
                width: MediaQuery.of(context).size.width,
                child: Card(
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text("Title: ${post.title}"),
                        Text("Text: ${post.body}"),
                      ],
                    ),
                  ),
                ),
              ),
              const Padding(padding: EdgeInsets.all(8.0), child: Center(child: Text("Comments"))),
              BlocBuilder<CommentsBloc, CommentState>(
                builder: (context, state) {
                  final comments = state.comments;
                  switch (state.fetchStatus) {
                    case FetchStatus.initial:
                      return const Center(child: Text("Loading"));
                    case FetchStatus.success:
                      return Expanded(
                          child: Scrollbar(
                        child: ListView(children: [
                          ...comments.map((e) {
                            return Card(
                              child: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                                  Text("Name: ${e.name}"),
                                  Text("Email: ${e.email}"),
                                  const Divider(),
                                  Text("Body: ${e.body}"),
                                ]),
                              ),
                            );
                          }),
                        ]),
                      ));
                    case FetchStatus.failure:
                      return const Center(child: Text("Failed to load comments"));
                  }
                },
              ),
            ],
          ),
        ));
  }

  Future<void> _addCommentDialog(BuildContext context) async {
    return showDialog(
        context: context,
        builder: (_) {
          return BlocProvider.value(
              value: CommentsBloc(_.read<AppRepository>(), post),
              child: AlertDialog(
                contentPadding: const EdgeInsets.fromLTRB(24, 12, 24, 12),
                backgroundColor: Theme.of(context).backgroundColor,
                content: SizedBox(
                  width: MediaQuery.of(context).size.width,
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      TextField(
                        keyboardType: TextInputType.name,
                        onChanged: (value) {
                          context.read<CommentsBloc>().add(CommentNameChanged(value));
                        },
                        decoration: const InputDecoration(
                          hintText: "Name",
                        ),
                      ),
                      TextField(
                        keyboardType: TextInputType.emailAddress,
                        onChanged: (value) {
                          context.read<CommentsBloc>().add(CommentEmailChanged(value));
                        },
                        decoration: const InputDecoration(
                          hintText: "Email",
                        ),
                      ),
                      TextField(
                        onChanged: (value) {
                          context.read<CommentsBloc>().add(CommentTextChanged(value));
                        },
                        decoration: const InputDecoration(
                          hintText: "Text",
                        ),
                        maxLength: 140,
                      ),
                    ],
                  ),
                ),
                actions: <Widget>[
                  TextButton(
                      onPressed: () {
                        context.read<CommentsBloc>().add(const CommentSubmitted());
                        Navigator.of(context).pop();
                      },
                      child: const Text("Send"))
                ],
              ));
        });
  }
}
