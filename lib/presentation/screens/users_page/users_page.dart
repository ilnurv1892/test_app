import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shimmer/shimmer.dart';
import 'package:test_app/domain/models/user.dart';
import 'package:test_app/domain/repository/app_repository.dart';
import 'package:test_app/presentation/screens/users_page/bloc/user_bloc.dart';
import 'package:test_app/presentation/screens/profile_page/profile.dart';
import 'package:test_app/presentation/fetch_status.dart';

class UsersScreen extends StatelessWidget {
  const UsersScreen({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
        create: (_) => UserBloc(
              appRepository: _.read<AppRepository>(),
            )..add(const FetchUsersEvent()),
        child: Scaffold(
          backgroundColor: Theme.of(context).backgroundColor,
          appBar: AppBar(
            title: const Text('Users'),
          ),
          body: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: BlocBuilder<UserBloc, UserState>(
                builder: (context, state) {
                  switch (state.fetchStatus) {
                    case FetchStatus.initial:
                      return const InitialShimmer();

                    case FetchStatus.success:
                      return const UserList();

                    case FetchStatus.failure:
                      return const Center(child: Text("Cant load data"));
                  }
                },
              ),
            ),
          ),
        ));
  }
}

class UserList extends StatelessWidget {
  const UserList({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final state = context.read<UserBloc>().state;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        ...state.userList.map((e) => UserTile(e)).toList(),
      ],
    );
  }
}

class InitialShimmer extends StatelessWidget {
  const InitialShimmer({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: MediaQuery.of(context).size.height,
      child: ListView.builder(
          itemCount: 10,
          itemBuilder: (context, position) {
            return Card(
              child: Container(
                height: 50,
                margin: const EdgeInsets.all(12),
                child: Shimmer.fromColors(
                    period: const Duration(seconds: 3),
                    baseColor: Colors.white,
                    highlightColor: Colors.grey.shade200,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Container(
                          decoration: const BoxDecoration(
                            borderRadius: BorderRadius.all(Radius.circular(5.0)),
                            color: Colors.grey,
                          ),
                          height: 10,
                          width: 100,
                        ),
                        const SizedBox(
                          height: 10,
                        ),
                        Container(
                          decoration: const BoxDecoration(
                            borderRadius: BorderRadius.all(Radius.circular(5.0)),
                            color: Colors.grey,
                          ),
                          height: 10,
                          width: 200,
                        ),
                      ],
                    )),
              ),
            );
          }),
    );
  }
}

class UserTile extends StatelessWidget {
  const UserTile(
    this.user, {
    Key? key,
  }) : super(key: key);

  final User user;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () => {
        HapticFeedback.lightImpact(),
        Navigator.of(context).push(Profile.route(user)),
      },
      child: Card(
        child: Container(
          height: 50,
          margin: const EdgeInsets.all(12),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(user.userName),
              Text(user.name),
            ],
          ),
        ),
      ),
    );
  }
}
