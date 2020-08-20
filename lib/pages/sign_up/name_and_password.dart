import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:instagramapp/data/data.dart';
import 'package:instagramapp/pages/sign_up/add_photo.dart';
import 'package:instagramapp/services/profile_service.dart';
import 'package:instagramapp/services/auth.dart';
import 'package:instagramapp/services/navigation_functions.dart';

class NameAndPassword extends StatefulWidget {
  final String email;

  NameAndPassword({this.email});

  @override
  _NameAndPasswordState createState() => _NameAndPasswordState();
}

class _NameAndPasswordState extends State<NameAndPassword> {
  String password = '';
  String name = '';
  TextEditingController nameController = TextEditingController();
  TextEditingController passwordController = TextEditingController();


  void registerUser() async{
    final AuthService _auth = AuthService();
    ProfileService profileService = ProfileService();

    if (widget.email != null && passwordController.text.isNotEmpty) {
     await _auth
          .createUserWithEmail(widget.email, password ,name).then((value){
//            print('41264*9/5-*5');
       print('AuthService.defaultUser.id is ${Data.defaultUser.id}');
     });
     print('AuthService.defaultUser.id is ${Data.defaultUser.id}');

         await profileService.setDataForNewUser();

         NavigationFunctions.navigateToPageAndRemoveRoot(context, AddPhoto());

        } else {
          print('Something error');
        }
      }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(children: <Widget>[
        Container(
          height: MediaQuery.of(context).size.height * 0.2,
        ),
        Text(
          'NAME AND PASSWORD',
          style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
        ),
        TextFormField(
          controller: nameController,
          onChanged: (val){
            setState(() {
              name = val;
            });
          },
          decoration: InputDecoration(
            hintText: "Full Name",
            filled: true,
          ),
        ),
        TextFormField(
          controller: passwordController,
          obscureText: true,
          onChanged: (val){
            setState(() {
              password = val;
            });
          },
          decoration: InputDecoration(
            hintText: "Password",
            filled: true,
          ),
        ),
        Container(
          width: double.infinity,
          child: RaisedButton(
            color: Colors.blue,
            onPressed: name !='' && password !=''? registerUser: null,
            child: Text('Continue'),
          ),
        )
      ]),
    );
  }
}
