part of 'user_bloc.dart';

class UserState extends Equatable {
  const UserState({this.fetchStatus = FetchStatus.initial, this.userList = const []});

  final FetchStatus fetchStatus;
  final List<User> userList;

  UserState copyWith({
    FetchStatus? fetchStatus,
    List<User>? userList,
  }) {
    return UserState(
      fetchStatus: fetchStatus ?? this.fetchStatus,
      userList: userList ?? this.userList,
    );
  }

  @override
  List<Object> get props => [fetchStatus, userList];
}
