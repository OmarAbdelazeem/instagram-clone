import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:instagramapp/src/core/utils/navigation_utils.dart';
import 'package:instagramapp/src/ui/screens/people_suggestions_screen/people_suggestions_screen.dart';

import '../../../../router.dart';

class ProfilePhotoAddedScreen extends StatefulWidget {
  @override
  _ProfilePhotoAddedScreenState createState() =>
      _ProfilePhotoAddedScreenState();
}

class _ProfilePhotoAddedScreenState extends State<ProfilePhotoAddedScreen> {
  @override
  Widget build(BuildContext context) {
    final imageUrl = ModalRoute.of(context)!.settings.arguments as String;
    return Scaffold(
      body: SafeArea(
        child: Container(
          width: double.infinity,
          child: Column(
            children: <Widget>[
              Padding(
                padding: const EdgeInsets.all(20.0),
                child: CircleAvatar(
                  radius: 40,
                  backgroundColor: Colors.grey,
                  child: CachedNetworkImage(
                    imageUrl: imageUrl,
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
                  onPressed: () => NavigationUtils.pushNamed(
                      route: AppRoutes.peopleSuggestionsScreen,
                      context: context),
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
