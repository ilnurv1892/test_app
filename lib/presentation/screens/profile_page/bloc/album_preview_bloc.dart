import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:test_app/domain/models/album.dart';
import 'package:test_app/domain/repository/app_repository.dart';
import 'package:test_app/presentation/fetch_status.dart';

part 'album_preview_event.dart';
part 'album_preview_state.dart';

class AlbumPreviewBloc extends Bloc<AlbumPreviewEvent, AlbumPreviewState> {
  final AppRepository appRepository;
  final int userId;
  AlbumPreviewBloc(this.appRepository, this.userId) : super(const AlbumPreviewState()) {
    on<AlbumPreviewEvent>(_onAlbumFetched);
  }

  _onAlbumFetched(
    AlbumPreviewEvent event,
    Emitter<AlbumPreviewState> emit,
  ) async {
    try {
      if (state.fetchStatus == FetchStatus.initial) {
        final album = await appRepository.fetchAlbumByUserId(userId).then((value) => value.take(3).toList());
        emit(state.copyWith(
          album: album,
          fetchStatus: FetchStatus.success,
        ));
      }
    } catch (_) {
      emit(state.copyWith(fetchStatus: FetchStatus.failure));
    }
  }
}
