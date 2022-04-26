import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:test_app/domain/models/user.dart';
import 'package:test_app/domain/repository/app_repository.dart';
import 'package:test_app/presentation/fetch_status.dart';

part 'user_event.dart';
part 'user_state.dart';

class UserBloc extends Bloc<FetchUsersEvent, UserState> {
  final AppRepository appRepository;

  UserBloc({required this.appRepository}) : super(const UserState()) {
    on<FetchUsersEvent>(_onUsersFetched);
  }

  _onUsersFetched(
    FetchUsersEvent event,
    Emitter<UserState> emit,
  ) async {
    try {
      if (state.fetchStatus == FetchStatus.initial) {
        final users = await appRepository.fetchUsers();
        emit(state.copyWith(
          fetchStatus: FetchStatus.success,
          userList: users,
        ));
      }
    } catch (_) {
      emit(state.copyWith(fetchStatus: FetchStatus.failure));
    }
  }
}
