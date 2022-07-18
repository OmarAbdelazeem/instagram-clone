import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:instagramapp/router.dart';
import 'package:instagramapp/src/bloc/auth_bloc/auth_bloc.dart';
import 'package:instagramapp/src/bloc/bottom_navigation_bar_cubit/bottom_navigation_bar_cubit.dart';
import 'package:instagramapp/src/bloc/firebase_notifications_bloc/firebase_notifications_bloc.dart';
import 'package:instagramapp/src/bloc/following_bloc/following_bloc.dart';
import 'package:instagramapp/src/bloc/logged_in_user_bloc/logged_in_user_bloc.dart';
import 'package:instagramapp/src/bloc/posts_bloc/posts_bloc.dart';
import 'package:instagramapp/src/bloc/time_line_bloc/time_line_bloc.dart';
import 'package:instagramapp/src/bloc/users_bloc/users_bloc.dart';
import 'package:instagramapp/src/repository/data_repository.dart';
import 'package:instagramapp/src/repository/posts_repository.dart';
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
            create: (context) => DataRepository(context.read<AuthRepository>()),
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
            BlocProvider<UsersBloc>(create: (context) => UsersBloc()),
            BlocProvider<PostsBloc>(create: (context) => PostsBloc()),
            BlocProvider<LoggedInUserBloc>(
                create: (context) => LoggedInUserBloc(
                      context.read<DataRepository>(),
                      context.read<AuthRepository>(),
                      context.read<PostsBloc>(),
                    )),
            BlocProvider<LoggedInUserBloc>(
                create: (context) => LoggedInUserBloc(
                      context.read<DataRepository>(),
                      context.read<AuthRepository>(),
                      context.read<PostsBloc>(),
                    )),
            BlocProvider<TimeLineBloc>(
                create: (context) => TimeLineBloc(
                      context.read<DataRepository>(),
                      context.read<PostsBloc>(),
                    )),
            BlocProvider<BottomNavigationBarCubit>(
                create: (context) => BottomNavigationBarCubit()),
            BlocProvider<FirebaseNotificationsBloc>(
                create: (context) =>
                    FirebaseNotificationsBloc(context.read<DataRepository>())),
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
