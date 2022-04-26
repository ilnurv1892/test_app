part of 'album_bloc.dart';

class AlbumState extends Equatable {
  final FetchStatus fetchStatus;
  final List<Album> albumList;

  const AlbumState({this.fetchStatus = FetchStatus.initial, this.albumList = const []});

  AlbumState copyWith({
    FetchStatus? fetchStatus,
    List<Album>? albumList,
  }) {
    return AlbumState(
      fetchStatus: fetchStatus ?? this.fetchStatus,
      albumList: albumList ?? this.albumList,
    );
  }

  @override
  List<Object> get props => [fetchStatus, albumList];
}
