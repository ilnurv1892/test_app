part of 'send_comment_bloc.dart';

abstract class CommentEvent extends Equatable {
  const CommentEvent();

  @override
  List<Object> get props => [];
}

class CommentNameChanged extends CommentEvent {
  const CommentNameChanged(this.name);

  final String name;

  @override
  List<Object> get props => [name];
}

class CommentEmailChanged extends CommentEvent {
  const CommentEmailChanged(this.email);

  final String email;

  @override
  List<Object> get props => [email];
}

class CommentTextChanged extends CommentEvent {
  const CommentTextChanged(this.text);

  final String text;

  @override
  List<Object> get props => [text];
}

class CommentSubmitted extends CommentEvent {
  const CommentSubmitted();
}

class CommentsFetched extends CommentEvent {}
