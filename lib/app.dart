import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:instagramapp/router.dart';
import 'package:instagramapp/src/bloc/auth_bloc/auth_bloc.dart';
import 'package:instagramapp/src/bloc/posts_bloc/posts_bloc.dart';
import 'package:instagramapp/src/bloc/users_bloc/users_bloc.dart';
import 'package:instagramapp/src/repository/data_repository.dart';
import 'package:instagramapp/src/repository/storage_repository.dart';

import 'src/repository/auth_repository.dart';

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MultiRepositoryProvider(

        ///
        /// Repositories
        ///
        providers: [
          RepositoryProvider<AuthRepository>(
            create: (context) => AuthRepository(),
          ),
          RepositoryProvider<DataRepository>(
            create: (context) => DataRepository(),
          ),
          RepositoryProvider<StorageRepository>(
            create: (context) => StorageRepository(),
          ),
        ],
        child: MultiBlocProvider(
          providers: [
            ///
            /// BLoCs
            ///
            BlocProvider<AuthBloc>(
              create: (context) => AuthBloc(
                  context.read<AuthRepository>(),
                  context.read<DataRepository>(),
                  context.read<StorageRepository>()),
            ),
            BlocProvider<PostsBloc>(
              create: (context) => PostsBloc(context.read<DataRepository>(),
                  context.read<AuthRepository>()),
            ),
            BlocProvider<UsersBloc>(
              create: (context) => UsersBloc(context.read<DataRepository>(),
                  context.read<AuthRepository>()),
            ),
          ],
          child: MaterialApp(
            debugShowCheckedModeBanner: false,
            initialRoute: AppRoutes.authScreen,
            onGenerateRoute: AppRouter().onGenerateRoute,
          ),
        ));
  }
}
