import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:instagramapp/router.dart';
import 'package:instagramapp/src/bloc/auth_bloc/auth_bloc.dart';
import 'package:instagramapp/src/bloc/following_bloc/following_bloc.dart';
import 'package:instagramapp/src/bloc/likes_bloc/likes_bloc.dart';
import 'package:instagramapp/src/bloc/logged_in_user_bloc/logged_in_user_bloc.dart';
import 'package:instagramapp/src/bloc/post_item_bloc/post_item_bloc.dart';
import 'package:instagramapp/src/bloc/posts_bloc/posts_bloc.dart';
import 'package:instagramapp/src/bloc/searched_user_bloc/searched_user_bloc.dart';
import 'package:instagramapp/src/bloc/users_bloc/users_bloc.dart';
import 'package:instagramapp/src/core/saved_posts_likes.dart';
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
          RepositoryProvider<OfflineLikesRepository>(
            create: (context) => OfflineLikesRepository(),
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
            BlocProvider<FollowingBloc>(create: (context) => FollowingBloc()),
            BlocProvider<LikesBloc>(create: (context) => LikesBloc()),
            BlocProvider<LoggedInUserBloc>(
                create: (context) => LoggedInUserBloc(
                      context.read<DataRepository>(),
                      context.read<LikesBloc>(),
                    )),
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
