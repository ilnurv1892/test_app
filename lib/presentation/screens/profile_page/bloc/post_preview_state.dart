part of 'post_preview_bloc.dart';

class PostPreviewState extends Equatable {
  final FetchStatus fetchStatus;
  final List<Post> post;

  const PostPreviewState({this.fetchStatus = FetchStatus.initial, this.post = const []});

  PostPreviewState copyWith({
    FetchStatus? fetchStatus,
    List<Post>? post,
  }) {
    return PostPreviewState(
      fetchStatus: fetchStatus ?? this.fetchStatus,
      post: post ?? this.post,
    );
  }

  @override
  List<Object> get props => [fetchStatus, post];
}
