import 'package:firebase_auth/firebase_auth.dart';
import 'package:instagramapp/data/data.dart';
import 'package:instagramapp/models/user.dart';
import 'package:instagramapp/services/profile_service.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AuthService {
  final FirebaseAuth _firebaseInstance = FirebaseAuth.instance;
//  final DateTime timestamp = DateTime.now();

  SharedPreferences _prefs;
  var _user;
  User _loggedInUser;

  ProfileService _profileService = ProfileService();
//  static User defaultUser;

  Future createUserWithEmail(String email, String password, String name) async {
    if (email != null && password != null) {
      try {
        _prefs = await SharedPreferences.getInstance();
        print('email is $email and password is $password');
        _user = await _firebaseInstance.createUserWithEmailAndPassword(
            email: email, password: password);

        _loggedInUser =  _firebaseInstance.currentUser;

        Data.defaultUser = UserModel(
            bio: '',
            name: email,
            userName: name,
            photoUrl: '',
            searchedUserId: _loggedInUser.uid);

        _prefs.setString('email', email);
        _prefs.setString('password', password);

        return await _user;
      } catch (e) {
        print(e);
      }
    }
  }

  Future signInWithEmail(String email, String password) async {
    if (email != null && password != null) {
      try {
        final SharedPreferences prefs = await SharedPreferences.getInstance();
        _user = await _firebaseInstance.signInWithEmailAndPassword(
            email: email, password: password);
        _loggedInUser = _firebaseInstance.currentUser;

        Data.defaultUser =
            await _profileService.getProfileMainInfo(searchedUserId: _loggedInUser.uid);

        prefs.setString('email', email);
        prefs.setString('password', password);
      } catch (e) {
        print(e);
      }
    }
    return _user;
  }

  Future<int> autoLogIn() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    final String email = prefs.getString('email');
    final String password = prefs.getString('password');

    if (email != null && password != null) {
      await signInWithEmail(email, password);

      return 1;
    } else
      return 0;
  }

  Future<Null> logout() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    _firebaseInstance.signOut();
    prefs.setString('email', null);
    prefs.setString('password', null);
  }

//  Future updateDefaultUser() async {
//    Data.defaultUser = await _profileService.getProfileMainInfo(id: Data.defaultUser.id);
//  }
}
