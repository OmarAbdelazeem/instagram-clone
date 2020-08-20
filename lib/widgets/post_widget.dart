import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:instagramapp/data/data.dart';
import 'package:instagramapp/models/post.dart';
import 'package:instagramapp/models/user.dart';
import 'package:instagramapp/pages/comments_screen.dart';
import 'package:instagramapp/pages/profile_components/my_profile.dart';
import 'package:instagramapp/pages/user_profile.dart';
import 'package:instagramapp/services/navigation_functions.dart';
import 'package:instagramapp/services/posts_service.dart';
import 'package:instagramapp/pages/profile_components/profile_details.dart';

class PostWidget extends StatefulWidget {
  final Post post;

  PostWidget({this.post});

  @override
  _PostWidgetState createState() => _PostWidgetState();
}

class _PostWidgetState extends State<PostWidget> {
  bool isLiking = false;
  int postLikesCount;
  PostServices postServices = PostServices();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    Data.changeCurrentPost(widget.post);

    postServices.checkIfLiking().then((value) {
      getLikesCount();
      setState(() {
        isLiking = value;
      });
    });
  }
  void getLikesCount(){
    postLikesCount = widget.post.postLikes.length;
  }
  void likeButton() {
    Data.changeCurrentPost(widget.post);
    setState(() {
      isLiking ? postLikesCount-= 1: postLikesCount+= 1;
      isLiking = !isLiking;
    });
    postServices.handleLiking(isLiking: !isLiking);
  }

  void commentButton() {
    Data.changeCurrentPost(widget.post);
    print('comment button pressed');
    NavigationFunctions.pushPage(
        context: context,
        isHorizontalNavigation: false,
        page: CommentsScreen());
//    NavigationFunctions.navigateToPage(context, CommentsScreen());
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Container(
          width: double.infinity,
          child: Padding(
            padding: const EdgeInsets.all(12.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Container(
                  width: MediaQuery.of(context).size.width * 0.5,
                  child: Row(
                    children: <Widget>[
                      Container(
                        child: userProfilePhoto(
                            photoUrl: widget.post.publisherProfilePhotoUrl),
                        width: 50,
                        height: 50,
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Text(widget.post.name),
                      )
                    ],
                  ),
                ),
                Icon(Icons.more_vert)
              ],
            ),
          ),
        ),
        Image.network(
          widget.post.photoUrl,
          width: double.infinity,
          height: MediaQuery.of(context).size.height * 0.4,
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            Row(
              children: <Widget>[
                IconButton(
                    icon: !isLiking
                        ? Icon(
                            Icons.favorite_border,
                          )
                        : Icon(Icons.favorite),
                    onPressed: likeButton),
                IconButton(
                    icon: SvgPicture.asset('assets/images/comment.svg',width: 20,height: 20,), onPressed: commentButton),
                IconButton(
                  icon: SvgPicture.asset('assets/images/send.svg',width: 20,height: 20,),
                  onPressed: () {
                    print('send button pressed');
                  },
                ),
              ],
            ),
            IconButton(
              icon: Icon(Icons.bookmark_border),
              onPressed: () {
                print('bookmark button pressed');
              },
            ),
          ],
        ),
        Padding(
          child: Text(
            '$postLikesCount likes',
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
          padding: EdgeInsets.only(left: 15, bottom: 5),
        ),
        Padding(
          child: Row(
            children: <Widget>[
              Text(
                widget.post.name,
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              SizedBox(
                width: 5,
              ),
              Text(
                widget.post.caption,
                style: TextStyle(fontSize: 16),
              ),
            ],
          ),
          padding: EdgeInsets.only(left: 15),
        )
      ],
    );
  }
}
