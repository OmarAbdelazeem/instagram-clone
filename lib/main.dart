
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:instagramapp/app.dart';

main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MyApp());
}


//1) handle if user tap on it's profile from timeline
//2) handle when user follow someone in his profile posts take unexpected behaviour
//3) make droplist in post view has more actions (done)
//4) when delete user delete all posts . (done)
//5) when delete post delete all likes and comments and delete it from Followers timeline (done)
//6) add delete , edit , share to droplist of post as bottom sheet (done)
//7) there is a bug after register


