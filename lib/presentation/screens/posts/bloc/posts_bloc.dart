import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:test_app/domain/models/post.dart';
import 'package:test_app/domain/repository/app_repository.dart';
import 'package:test_app/presentation/fetch_status.dart';

part 'posts_event.dart';
part 'posts_state.dart';

class PostsBloc extends Bloc<PostEvent, PostsState> {
  final AppRepository appRepository;
  final int userId;
  PostsBloc(this.appRepository, this.userId) : super(const PostsState()) {
    on<PostEvent>(_onPostsFetched);
  }

  _onPostsFetched(
    PostEvent event,
    Emitter<PostsState> emit,
  ) async {
    try {
      if (state.fetchStatus == FetchStatus.initial) {
        final posts = await appRepository.fetchPostByUserId(userId).then((value) => value.toList());

        emit(state.copyWith(postsList: posts, fetchStatus: FetchStatus.success));
      }
    } catch (_) {
      emit(state.copyWith(fetchStatus: FetchStatus.failure));
    }
  }
}
