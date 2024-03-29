import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:instagramapp/router.dart';
import 'package:instagramapp/src/bloc/auth_bloc/auth_bloc.dart';
import 'package:instagramapp/src/bloc/follow_bloc/follow_bloc.dart';
import 'package:instagramapp/src/bloc/posts_bloc/posts_bloc.dart';
import 'package:instagramapp/src/bloc/profile_bloc/profile_bloc.dart';
import 'package:instagramapp/src/bloc/users_bloc/users_bloc.dart';
import 'package:instagramapp/src/repository/data_repository.dart';
import 'package:instagramapp/src/repository/storage_repository.dart';
import 'package:instagramapp/src/res/app_thems.dart';
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
              create: (context) => PostsBloc(
                context.read<DataRepository>(),
                context.read<StorageRepository>(),
              ),
            ),
            BlocProvider<UsersBloc>(
              create: (context) => UsersBloc(
                context.read<DataRepository>(),
              ),
            ),
            BlocProvider<FollowBloc>(
              create: (context) => FollowBloc(
                context.read<DataRepository>(),
              ),
            ),
            BlocProvider<ProfileBloc>(
              create: (context) => ProfileBloc(),
            ),
          ],
          child: MaterialApp(
            debugShowCheckedModeBanner: false,
            initialRoute: AppRoutes.splashScreen,
            theme: AppThemes.lightTheme,
            onGenerateRoute: AppRouter().onGenerateRoute,
          ),
        ));
  }
}
