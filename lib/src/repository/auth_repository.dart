import 'package:firebase_auth/firebase_auth.dart';
import 'package:instagramapp/src/models/user_model/user_model.dart';

class AuthRepository {
  final FirebaseAuth _firebaseInstance = FirebaseAuth.instance;
  var _user;
  User? loggedInUser;

  Future createUserWithEmail(String email, String password, String name) async {
    try {
      _user = await _firebaseInstance.createUserWithEmailAndPassword(
          email: email, password: password);

      loggedInUser = _firebaseInstance.currentUser;

      return await _user;
    } catch (e) {
      print(e);
    }
  }

  Future signInWithEmail(String email, String password) async {
    try {
      _user = await _firebaseInstance.signInWithEmailAndPassword(
          email: email, password: password);
      loggedInUser = _firebaseInstance.currentUser;
    } catch (e) {
      print(e);
    }
    return _user;
  }

  Future<Null> logout() async {
    _firebaseInstance.signOut();
  }
}
