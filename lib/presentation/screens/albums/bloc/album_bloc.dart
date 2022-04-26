import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:test_app/domain/models/album.dart';
import 'package:test_app/domain/repository/app_repository.dart';
import 'package:test_app/presentation/fetch_status.dart';

part 'album_event.dart';
part 'album_state.dart';

class AlbumBloc extends Bloc<AlbumEvent, AlbumState> {
  final AppRepository appRepository;
  final int userId;
  AlbumBloc(this.appRepository, this.userId) : super(const AlbumState()) {
    on<AlbumEvent>(_onAlbumFetched);
  }

  _onAlbumFetched(AlbumEvent event, Emitter<AlbumState> emit) async {
    try {
      if (state.fetchStatus == FetchStatus.initial) {
        List<Album> albumList = await appRepository.fetchAlbumByUserId(userId).then((value) => value.toList());
        emit(state.copyWith(albumList: albumList, fetchStatus: FetchStatus.success));
      }
    } catch (_) {
      emit(state.copyWith(fetchStatus: FetchStatus.failure));
    }
  }
}
