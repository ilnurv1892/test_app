import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:test_app/data/api/local_api.dart';
import 'package:test_app/data/api/remote_api.dart';
import 'package:test_app/data/repository/repository_iml.dart';
import 'package:test_app/presentation/screens/home_page.dart';

void main() {
  return BlocOverrides.runZoned(
    () async {
      runApp(HomePage(
          appRepository: AppRepositoryImpl(
        LocalApi(),
        RemoteApi(),
      )));
    },
  );
}
