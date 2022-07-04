import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:instagramapp/app.dart';

Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  await Firebase.initializeApp();
  print('A bg message just showed up :  ${message.messageId}');
}

// RemoteMessage? initialMessage;
main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);
  // initialMessage = await FirebaseMessaging.instance.getInitialMessage();


  runApp(MyApp());
}



//1) handle if user tap on it's profile from timeline (done)
//2) handle when user follow someone in his profile posts take unexpected behaviour (done)
//3) listen to timeline if new post id is equal to uploaded post id then add it to time line (done)
//4) make edit bio and username is active (done)
//5) make delete ,edit and share post active
//6) make notification
//7) reverse list of comments to show the last comment as first seen
//8) make unavailable features open screen of coming soon
//9) make paginagation
//10) make share your first post active (done)
//11) when following someone increase followers and following count not by stream and vise versa in unfollowing
//12) add post publisher id to comment model (done)
//13) when user logout and login again it be taken to profile screen
//14) edit post
//15) before send notification check if this is the owner of post
//16) open notification from outside app
//17) fix followers bug




