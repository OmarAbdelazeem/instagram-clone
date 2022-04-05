import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:instagramapp/src/core/utils/navigation_utils.dart';
import 'package:instagramapp/src/res/app_images.dart';
import 'package:instagramapp/src/ui/common/profile_photo.dart';
import '../../../router.dart';
import '../../models/post_model/post_model.dart';
import '../../res/app_strings.dart';

// Todo refactor this file
class PostWidget extends StatefulWidget {
  final PostModel post;

  PostWidget({required this.post});

  @override
  _PostWidgetState createState() => _PostWidgetState();
}

class _PostWidgetState extends State<PostWidget> {
  bool isLiked = false;
  int? postLikesCount = 0;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  void getLikesCount() {
    // postLikesCount = widget.post.likesCount;
  }

  void likeButton() {
    //Todo implement like function
    setState(() {
      isLiked = !isLiked;
    });
  }

  void commentButton() {
    NavigationUtils.pushNamed(
        route: AppRoutes.commentsScreen, context: context);
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Padding(
            padding: EdgeInsets.symmetric(vertical: 4, horizontal: 8),
            child: _buildPostHeader()),
        _buildPostImage(),
        _buildPostActions(),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [buildLikesCount(), buildPublisherNameAndCaption()],
          ),
        )
      ],
    );
  }

  Widget buildPublisherNameAndCaption() {
    return Row(
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
    );
  }

  Widget buildLikesCount() {
    return Text(
      '$postLikesCount ${AppStrings.likes}',
      style: TextStyle(fontWeight: FontWeight.bold),
    );
  }

  Row _buildPostActions() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: <Widget>[
        Row(
          children: <Widget>[
            IconButton(
                icon: !isLiked
                    ? Icon(
                        Icons.favorite_border,
                      )
                    : Icon(Icons.favorite),
                onPressed: likeButton),
            IconButton(
                icon: SvgPicture.asset(
                  AppImages.commentButtonSvg,
                  width: 20,
                  height: 20,
                ),
                onPressed: commentButton),
            IconButton(
              icon: SvgPicture.asset(
                AppImages.sendButtonSvg,
                width: 20,
                height: 20,
              ),
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
    );
  }

  Image _buildPostImage() {
    return Image.network(
      widget.post.photoUrl,
      width: double.infinity,
      height: 250,
    );
  }

  Widget _buildPostHeader() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: <Widget>[
        Row(
          children: <Widget>[
            ProfilePhoto(photoUrl: widget.post.publisherProfilePhotoUrl),
            SizedBox(
              width: 8,
            ),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 4),
              child: Text(widget.post.publisherName),
            )
          ],
        ),
        IconButton(onPressed: () {}, icon: Icon(Icons.more_vert))
      ],
    );
  }
}
