import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:instagramapp/router.dart';
import 'package:instagramapp/src/bloc/auth_bloc/auth_bloc.dart';
import 'package:instagramapp/src/bloc/time_line_bloc/time_line_bloc.dart';
import 'package:instagramapp/src/bloc/users_bloc/users_bloc.dart';
import 'package:instagramapp/src/repository/data_repository.dart';

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
        ],
        child: MultiBlocProvider(
          providers: [
            ///
            /// BLoCs
            ///
            BlocProvider<AuthBloc>(
              create: (context) => AuthBloc(context.read<AuthRepository>()),
            ),
            BlocProvider<TimeLineBloc>(
              create: (context) => TimeLineBloc(context.read<DataRepository>(),
                  context.read<AuthRepository>()),
            ),
            BlocProvider<UsersBloc>(
              create: (context) => UsersBloc(context.read<DataRepository>(),
                  context.read<AuthRepository>()),
            ),
          ],
          child: MaterialApp(
            debugShowCheckedModeBanner: false,
            initialRoute: AppRoutes.mainHomeScreen,
            onGenerateRoute: AppRouter().onGenerateRoute,
          ),
        ));
  }
}
