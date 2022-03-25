import 'dart:io';
import 'package:flutter/material.dart';
import 'package:instagramapp/src/ui/screens/people_suggestions_screen/people_suggestions_screen.dart';


class ProfilePhotoAdded extends StatefulWidget {
 final File selectedFile;
  ProfilePhotoAdded(this.selectedFile);
  @override
  _ProfilePhotoAddedState createState() => _ProfilePhotoAddedState();
}

class _ProfilePhotoAddedState extends State<ProfilePhotoAdded> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Container(
          width: double.infinity,
          child: Column(
//          crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              Padding(
                padding: const EdgeInsets.all(20.0),
                child: CircleAvatar(
                  radius: 40,
                  backgroundColor: Colors.grey,
                  child:  Image.file(
                    widget.selectedFile,
//                    width: MediaQuery.of(context).size.width * 0.2,
//                    height: 70,
                    fit: BoxFit.cover,
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(bottom: 10),
                child: Text(
                  'Profile Photo Added',
                  style: TextStyle(fontSize: 28),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(bottom: 20),
                child: Text(
                  'change photo',
                  style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Colors.blue),
                ),
              ),
              Container(
                width: MediaQuery.of(context).size.width * 0.85,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    Text(
                      'Also share this photo as a post',
                      textAlign: TextAlign.center,
                      overflow: TextOverflow.clip,
                    ),
                    Switch(
                      onChanged: (val) {},
                      value: false,
                    ),
                  ],
                ),
              ),
              SizedBox(
                height: 5,
              ),
              Container(
                  width: MediaQuery.of(context).size.width * 0.85,
                  child: Text(
                    'Make this photo your first post so people can like and comment on it',
                    textAlign: TextAlign.start,
                  )),
              SizedBox(
                height: 15,
              ),
              Container(
                width: MediaQuery.of(context).size.width * 0.85,
                child: RaisedButton(
                  color: Colors.blue,
                  onPressed: () {
                    // Todo fix this as before
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) =>
                            PeopleSuggestionsScreen()));
                    // NavigationFunctions.navigateToPageAndRemoveRoot(context, PeopleSuggestion(),
                  },
                  child: Text(
                    'Next',
                    style: TextStyle(color: Colors.white),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
