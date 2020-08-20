import 'package:flutter/material.dart';
import 'package:instagramapp/pages/home.dart';
import 'package:instagramapp/pages/search_photos.dart';
import 'package:instagramapp/pages/sign_up/main_auth_page.dart';
import 'package:instagramapp/services/auth.dart';


main() {
  WidgetsFlutterBinding.ensureInitialized();
  AuthService _auth = AuthService();
  _auth.autoLogIn().then((value) {
    if (value == 1) {
      print(value);
      runApp(
        MyApp(
          Home(),
        ),
      );
    } else
      runApp(MyApp(
        MainAuthPage(),
      ));
  });
}


class MyApp extends StatelessWidget {
  final Widget page;

  MyApp(this.page);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      color: Colors.black,
      debugShowCheckedModeBanner: false,
      home: page
    );
  }
}
