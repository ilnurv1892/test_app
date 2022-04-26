import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:test_app/domain/models/comments.dart';
import 'package:test_app/domain/models/post.dart';
import 'package:test_app/domain/repository/app_repository.dart';
import 'package:test_app/presentation/fetch_status.dart';

part 'send_comment_event.dart';
part 'send_comment_state.dart';

class CommentsBloc extends Bloc<CommentEvent, CommentState> {
  final AppRepository appRepository;
  final Post post;

  CommentsBloc(this.appRepository, this.post) : super(const CommentState()) {
    on<CommentNameChanged>(_onNameChanged);
    on<CommentEmailChanged>(_onEmailChanged);
    on<CommentTextChanged>(_onTextChanged);
    on<CommentSubmitted>(_onCommentSubmitted);
    on<CommentsFetched>(_onCommentFetched);
  }

  _onCommentFetched(CommentsFetched event, Emitter<CommentState> emit) async {
    try {
      if (state.fetchStatus == FetchStatus.initial) {
        final comments = await appRepository.fetchCommentsByPostId(post.id);
        emit(state.copyWith(
          comments: comments,
          fetchStatus: FetchStatus.success,
        ));
      }
    } catch (_) {
      emit(state.copyWith(fetchStatus: FetchStatus.failure));
    }
  }

  void _onNameChanged(
    CommentNameChanged event,
    Emitter<CommentState> emit,
  ) {
    emit(state.copyWith(name: event.name));
  }

  void _onEmailChanged(
    CommentEmailChanged event,
    Emitter<CommentState> emit,
  ) {
    emit(state.copyWith(email: event.email));
  }

  void _onTextChanged(
    CommentTextChanged event,
    Emitter<CommentState> emit,
  ) {
    emit(state.copyWith(text: event.text));
  }

  Future<void> _onCommentSubmitted(
    CommentSubmitted event,
    Emitter<CommentState> emit,
  ) async {
    emit(state.copyWith(status: EditCommentStatus.loading, fetchStatus: FetchStatus.initial));

    final comment = Comment(
      postId: post.id,
      name: state.name,
      email: state.email,
      body: state.text,
      id: post.comments == null ? 1 : post.comments!.length + 1,
    );
    try {
      await appRepository.sendComment(comment, post.id);
      final comments = await appRepository.fetchCommentsByPostId(post.id);
      emit(state.copyWith(
          status: EditCommentStatus.success,
          fetchStatus: FetchStatus.success,
          comments: comments,
          name: '',
          email: '',
          text: ''));
    } catch (e) {
      emit(state.copyWith(status: EditCommentStatus.failure));
    }
  }
}
