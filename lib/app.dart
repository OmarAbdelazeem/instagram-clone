import 'package:flutter/material.dart';
import 'package:instagramapp/router.dart';

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      initialRoute: AppRoutes.authScreen,
      onGenerateRoute: AppRouter().onGenerateRoute,
    );
  }
}
