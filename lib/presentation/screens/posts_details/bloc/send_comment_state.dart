part of 'send_comment_bloc.dart';

class CommentState extends Equatable {
  const CommentState(
      {this.status = EditCommentStatus.initial,
      this.fetchStatus = FetchStatus.initial,
      this.name = '',
      this.email = '',
      this.text = '',
      this.comments = const []});

  final EditCommentStatus status;
  final FetchStatus fetchStatus;
  final String name;
  final String email;
  final String text;
  final List<Comment> comments;

  CommentState copyWith(
      {EditCommentStatus? status,
      String? name,
      String? email,
      String? text,
      List<Comment>? comments,
      FetchStatus? fetchStatus}) {
    return CommentState(
      status: status ?? this.status,
      fetchStatus: fetchStatus ?? this.fetchStatus,
      name: name ?? this.name,
      email: email ?? this.email,
      text: text ?? this.text,
      comments: comments ?? this.comments,
    );
  }

  @override
  List<Object?> get props => [status, name, email, text, fetchStatus, comments];
}
