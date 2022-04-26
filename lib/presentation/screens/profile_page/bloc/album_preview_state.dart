part of 'album_preview_bloc.dart';

class AlbumPreviewState extends Equatable {
  final FetchStatus fetchStatus;
  final List<Album> album;

  const AlbumPreviewState({this.fetchStatus = FetchStatus.initial, this.album = const []});

  AlbumPreviewState copyWith({
    FetchStatus? fetchStatus,
    List<Album>? album,
  }) {
    return AlbumPreviewState(
      fetchStatus: fetchStatus ?? this.fetchStatus,
      album: album ?? this.album,
    );
  }

  @override
  List<Object> get props => [fetchStatus, album];
}
