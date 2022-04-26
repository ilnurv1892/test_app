part of 'posts_bloc.dart';

class PostsState extends Equatable {
  final FetchStatus fetchStatus;
  final List<Post> postsList;

  const PostsState({this.fetchStatus = FetchStatus.initial, this.postsList = const []});

  PostsState copyWith({
    FetchStatus? fetchStatus,
    List<Post>? postsList,
  }) {
    return PostsState(
      fetchStatus: fetchStatus ?? this.fetchStatus,
      postsList: postsList ?? this.postsList,
    );
  }

  @override
  List<Object> get props => [fetchStatus, postsList];
}
