import 'package:firebase_auth/firebase_auth.dart';

class AuthRepository {
  final FirebaseAuth _firebaseInstance = FirebaseAuth.instance;
  UserCredential? _userCredential;
  User? loggedInUser;

  Future<User?> createUserWithEmail(String email, String password) async {
    try {
      _userCredential = await _firebaseInstance.createUserWithEmailAndPassword(
          email: email, password: password);

      loggedInUser = _firebaseInstance.currentUser;

      return  loggedInUser;
    } catch (e) {
      print(e);
    }
    return null;
  }

  Future signInWithEmail(String email, String password) async {
    try {
      _userCredential = await _firebaseInstance.signInWithEmailAndPassword(
          email: email, password: password);
      loggedInUser = _firebaseInstance.currentUser;
    } catch (e) {
      print(e);
    }
    return loggedInUser;
  }

  Future<Null> logout() async {
    _firebaseInstance.signOut();
  }
}
