import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:instagramapp/src/bloc/auth_bloc/auth_bloc.dart';
import 'package:instagramapp/src/bloc/users_bloc/users_bloc.dart';
import '../../../../router.dart';
import '../../../core/utils/navigation_utils.dart';

class SplashScreen extends StatefulWidget {
  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    context.read<AuthBloc>().add(AutoLoginStarted());
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<AuthBloc, AuthState>(
      listener: (context, state) {
        print("state is $state");
        if (state is AuthSuccess) {
          NavigationUtils.pushNamedAndPopUntil(
              AppRoutes.mainHomeScreen, context);
          print("state.user id is ${state.user.id}");
          context.read<UsersBloc>().add(SetLoggedInUserStarted(state.user));
        } else
          NavigationUtils.pushNamedAndPopUntil(AppRoutes.authScreen, context);
      },
      child: Container(),
    );
  }
}
