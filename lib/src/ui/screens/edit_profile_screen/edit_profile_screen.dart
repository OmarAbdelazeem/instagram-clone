import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import "package:flutter/material.dart";
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:instagramapp/src/bloc/auth_bloc/auth_bloc.dart';
import '../../../models/user_model/user_model.dart';

class EditProfileScreen extends StatefulWidget {
  @override
  _EditProfileScreenState createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends State<EditProfileScreen> {
  final _scaffoldKey = GlobalKey<ScaffoldState>();
  TextEditingController displayNameController = TextEditingController();
  TextEditingController bioController = TextEditingController();
  bool isLoading = false;
  UserModel? user = UserModel(
      photoUrl:
          "https://media.wired.com/photos/5fb70f2ce7b75db783b7012c/master/pass/Gear-Photos-597589287.jpg",
      userName: "Omar Abdelazeem",
      bio: "this is a bio",
      id: "123",
      email: "omar@email.com",
      postsCount: 1,
      followersCount: 3,
      followingCount: 5,
      timestamp: (Timestamp.now()).toDate());
  bool _displayNameValid = true;
  bool _bioValid = true;

  @override
  void initState() {
    super.initState();
    // getUser();
  }

  // getUser() async {
  //   setState(() {
  //     isLoading = true;
  //   });
  //   DocumentSnapshot doc = await usersRef.doc(Data.defaultUser.id).get();
  //   user = UserModel.fromJson(doc);
  //   displayNameController.text = user.userName;
  //   bioController.text = user.bio;
  //   setState(() {
  //     isLoading = false;
  //   });
  // }

  Column buildDisplayNameField() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Padding(
            padding: EdgeInsets.only(top: 12.0),
            child: Text(
              "Display Name",
              style: TextStyle(color: Colors.grey),
            )),
        TextField(
          controller: displayNameController,
          decoration: InputDecoration(
            hintText: "Update Display Name",
            errorText: _displayNameValid ? null : "Display Name too short",
          ),
        )
      ],
    );
  }

  Column buildBioField() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Padding(
          padding: EdgeInsets.only(top: 12.0),
          child: Text(
            "Bio",
            style: TextStyle(color: Colors.grey),
          ),
        ),
        TextField(
          controller: bioController,
          decoration: InputDecoration(
            hintText: "Update Bio",
            errorText: _bioValid ? null : "Bio too long",
          ),
        )
      ],
    );
  }

  updateProfileData() {
    // setState(() {
    //   displayNameController.text.trim().length < 3 ||
    //           displayNameController.text.isEmpty
    //       ? _displayNameValid = false
    //       : _displayNameValid = true;
    //   bioController.text.trim().length > 100
    //       ? _bioValid = false
    //       : _bioValid = true;
    // });
    //
    // if (_displayNameValid && _bioValid) {
    //   usersRef.doc(Data.defaultUser.id).update({
    //     "displayName": displayNameController.text,
    //     "bio": bioController.text,
    //   });
    //   SnackBar snackbar = SnackBar(content: Text("Profile updated!"));
    //   _scaffoldKey.currentState.showSnackBar(snackbar);
    //   Navigator.pop(context);
    // }
  }

  logout() async {
    context.read<AuthBloc>().add(LogoutStarted());
    // AuthService authService = AuthService();
    // await authService.logout();
    // Navigator.of(context, rootNavigator: true).pushReplacement(
    //     MaterialPageRoute(builder: (context) => MainAuthPage()));
//    Navigator.push(context, MaterialPageRoute(builder: (context) => MainAuthPage()));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(
        iconTheme: IconThemeData(
          color: Colors.black, //change your color here
        ),
        backgroundColor: Colors.white,
        title: Text(
          "Edit Profile",
          style: TextStyle(
            color: Colors.black,
          ),
        ),
        actions: <Widget>[
          IconButton(
            onPressed: updateProfileData,
            icon: Icon(
              Icons.done,
              size: 30.0,
              color: Colors.blue,
            ),
          ),
        ],
      ),
      body: isLoading
          ? CircularProgressIndicator()
          : ListView(
              children: <Widget>[
                Container(
                  child: Column(
                    children: <Widget>[
                      Padding(
                        padding: EdgeInsets.only(
                          top: 16.0,
                          bottom: 8.0,
                        ),
                        child: CircleAvatar(
                          radius: 50.0,
                          backgroundImage:
                              CachedNetworkImageProvider(user!.photoUrl),
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.all(16.0),
                        child: Column(
                          children: <Widget>[
                            buildDisplayNameField(),
                            buildBioField(),
                          ],
                        ),
                      ),
//                      RaisedButton(
//                        onPressed: updateProfileData,
//                        child: Text(
//                          "Update Profile",
//                          style: TextStyle(
//                            color: Theme.of(context).primaryColor,
//                            fontSize: 20.0,
//                            fontWeight: FontWeight.bold,
//                          ),
//                        ),
//                      ),
                      Padding(
                        padding: EdgeInsets.all(16.0),
                        child: FlatButton.icon(
                          onPressed: logout,
                          icon: Icon(Icons.cancel, color: Colors.red),
                          label: Text(
                            "Logout",
                            style: TextStyle(color: Colors.red, fontSize: 20.0),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
    );
  }
}
