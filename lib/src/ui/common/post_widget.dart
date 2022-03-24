import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import '../../models/post_model/post_model.dart';


class PostWidget extends StatefulWidget {
  final PostModel post;

  PostWidget({required this.post});

  @override
  _PostWidgetState createState() => _PostWidgetState();
}

class _PostWidgetState extends State<PostWidget> {
  bool isLiking = false;
  int? postLikesCount;
  // PostServices postServices = PostServices();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    // Data.changeCurrentPost(widget.post);

    // postServices.checkIfUserLikesPost().then((value) {
    //   getLikesCount();
    //   setState(() {
    //     isLiking = value;
    //   });
    // });
  }
  void getLikesCount(){
    postLikesCount = widget.post.likesCount;
  }
  void likeButton() {
    // Data.changeCurrentPost(widget.post);
    // setState(() {
    //   isLiking ? postLikesCount-= 1: postLikesCount+= 1;
    //   isLiking = !isLiking;
    // });
    // postServices.handleLiking(isLiking: !isLiking);
  }

  void commentButton() {
    // Data.changeCurrentPost(widget.post);
    // print('comment button pressed');
    // NavigationFunctions.pushPage(
    //     context: context,
    //     isHorizontalNavigation: false,
    //     page: CommentsScreen());
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
                        child: Text(widget.post.publisherName),
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
                widget.post.publisherName,
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
  Widget userProfilePhoto({String? photoUrl}) {
    return photoUrl != null
        ? Container(
      height: 85,
      width: 85,
      child: CircleAvatar(
        radius: 30,
        backgroundColor: Color(0xffFDCF09),
        child: CircleAvatar(
            radius: 50, backgroundImage: NetworkImage(photoUrl)),
      ),
    )
        : Container(
      height: 85,
      width: 85,
      child: CircleAvatar(
        radius: 30,
        backgroundColor: Colors.grey,
        child: Icon(
          Icons.person_outline,
          size: 40,
          color: Colors.white,
        ),
      ),
    );
  }

}
