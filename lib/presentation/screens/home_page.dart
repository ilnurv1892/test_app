import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:test_app/domain/repository/app_repository.dart';
import 'package:test_app/presentation/screens/users_page/users_page.dart';

class HomePage extends StatelessWidget {
  const HomePage({
    required this.appRepository,
    Key? key,
  }) : super(key: key);

  final AppRepository appRepository;

  @override
  Widget build(BuildContext context) {
    return RepositoryProvider.value(
        value: appRepository,
        child: MaterialApp(
          theme: ThemeData.light(),
          home: const UsersScreen(),
        ));
  }
}
