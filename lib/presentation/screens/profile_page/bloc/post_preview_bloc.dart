import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:test_app/domain/models/post.dart';
import 'package:test_app/domain/repository/app_repository.dart';
import 'package:test_app/presentation/fetch_status.dart';

part 'post_preview_event.dart';
part 'post_preview_state.dart';

class PostPreviewBloc extends Bloc<PostPreviewEvent, PostPreviewState> {
  final AppRepository appRepository;
  final int userId;
  PostPreviewBloc(this.appRepository, this.userId) : super(const PostPreviewState()) {
    on<PostPreviewEvent>(_onPostsFetched);
  }

  _onPostsFetched(
    PostPreviewEvent event,
    Emitter<PostPreviewState> emit,
  ) async {
    try {
      if (state.fetchStatus == FetchStatus.initial) {
        final post = await appRepository.fetchPostByUserId(userId).then((value) => value.take(3).toList());

        emit(state.copyWith(
          post: post.toList(),
          fetchStatus: FetchStatus.success,
        ));
      }
    } catch (_) {
      emit(state.copyWith(fetchStatus: FetchStatus.failure));
    }
  }
}
