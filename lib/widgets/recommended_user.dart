import 'package:flutter/material.dart';
import 'package:instagramapp/data/data.dart';
import 'package:instagramapp/models/user.dart';
import 'package:instagramapp/pages/user_profile.dart';
import 'package:instagramapp/services/profile_service.dart';

class RecommendedUser extends StatefulWidget {
  final User user;

  RecommendedUser([this.user]);

  @override
  _RecommendedUserState createState() => _RecommendedUserState();
}

class _RecommendedUserState extends State<RecommendedUser> {
 bool isFollowing = false;
  ProfileService profileService = ProfileService();

 void followButton() {
   Data.changeCurrentUser(widget.user);
   setState(() {
     isFollowing = true;
   });
   profileService.followingOperation();
 }

 void unFollowButton() async{

   Data.changeCurrentUser(widget.user);
   setState(() {
     isFollowing = false;
   });
   await profileService.unFollowOperation();
 }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: (){
        Navigator.of(context).push(
          MaterialPageRoute(
            builder: (context) => UserProfile(),
          ),
        );
        Data.changeCurrentUser(widget.user);
      },
      child: Container(
        height: 150,
        width: 200,
        child: Card(
          elevation: 4,
          child: Padding(
            padding: EdgeInsets.all(15),
            child: Column(
              children: <Widget>[
            widget.user.photoUrl == ''
                ? CircleAvatar(
                    radius: 30,
                    backgroundColor: Colors.grey,
                    child: Icon(
                      Icons.person_outline,
                      size: 40,
                      color: Colors.white,
                    ),
                  )
                :
                CircleAvatar(
                        radius: 40,
                        backgroundColor: Color(0xffFDCF09),
                        child: CircleAvatar(
                          radius: 60,
                          backgroundImage: NetworkImage(
                              widget.user.photoUrl),
                        ),
                      ),
                SizedBox(height: 10,),
                Text(widget.user.userName,style: TextStyle(fontWeight: FontWeight.bold,fontSize: 17),),
                SizedBox(height: 5,),
                Text(widget.user.bio ,style: TextStyle(color: Colors.grey),),
                Container(
                  width: MediaQuery.of(context).size.width * 0.25,
                  child: RaisedButton(
                    color: !isFollowing ? Colors.blue : Colors.white,
                    onPressed: !isFollowing ? unFollowButton : followButton,
                    child: !isFollowing
                        ? Text(
                      'Follow',
                      style: TextStyle(color: Colors.white),
                    )
                        : Text('Following'),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
