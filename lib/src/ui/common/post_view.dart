import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:instagramapp/src/bloc/logged_in_user_bloc/logged_in_user_bloc.dart';
import 'package:instagramapp/src/core/utils/navigation_utils.dart';
import 'package:instagramapp/src/res/app_images.dart';
import 'package:instagramapp/src/ui/common/profile_photo.dart';
import 'package:instagramapp/src/ui/screens/comments_screen/comments_screen.dart';
import '../../bloc/post_item_bloc/post_item_bloc.dart';
import '../../core/saved_posts_likes.dart';
import '../../models/post_model/post_model.dart';
import '../../repository/data_repository.dart';
import '../../res/app_strings.dart';
import '../screens/profile_screen/searched_user_profile_screen.dart';

class PostView extends StatefulWidget {
  final PostModel post;

  PostView({
    required this.post,
  });

  @override
  _PostViewState createState() => _PostViewState();
}

class _PostViewState extends State<PostView> {
  late PostItemBloc postItemBloc;

  void likeButtonTapped() {
    if (postItemBloc.isLiked) {
      postItemBloc.add(RemoveLikeStarted(
          postId: widget.post.postId,
          userId: context.read<LoggedInUserBloc>().loggedInUser!.id!));
    } else {
      postItemBloc.add(AddLikeStarted(
          postId: widget.post.postId,
          userId: context.read<LoggedInUserBloc>().loggedInUser!.id!));
    }
  }

  void onCommentButtonTapped() {
    NavigationUtils.pushScreen(
        screen: CommentsScreen(widget.post, postItemBloc), context: context);
  }



  @override
  void initState() {
    postItemBloc = PostItemBloc(
        context.read<DataRepository>(), context.read<OfflineLikesRepository>());
    postItemBloc.setCurrentPost(widget.post);
    postItemBloc.add(CheckIfPostIsLikedStarted());
    // TODO: implement initState
    super.initState();
  }

  // @override
  // void didChangeDependencies() {
  //   postItemBloc = PostItemBloc(
  //       context.read<DataRepository>(), context.read<OfflineLikesRepository>());
  //   postItemBloc.setCurrentPost(widget.post);
  //   super.didChangeDependencies();
  // }

  @override
  Widget build(BuildContext context) {
    // postItemBloc.add(CheckIfPostIsLikedStarted());

    return BlocProvider(
      create: (_) => postItemBloc,
      child: Column(
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
              children: [_buildLikesCount(), _buildPublisherNameAndCaption()],
            ),
          )
        ],
      ),
    );
  }

  Widget _buildPublisherNameAndCaption() {
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

  Widget _buildLikesCount() {
    return BlocBuilder<PostItemBloc, PostItemState>(
      builder: (context, state) {
        return Text(
          '${postItemBloc.currentPost.likesCount} ${AppStrings.likes}',
          style: TextStyle(fontWeight: FontWeight.bold),
        );
      },
    );
  }

  Row _buildPostActions() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: <Widget>[
        Row(
          children: <Widget>[
            BlocBuilder<PostItemBloc, PostItemState>(builder: (context, state) {
              return IconButton(
                  icon: postItemBloc.isLiked
                      ? Icon(
                          Icons.favorite,
                        )
                      : Icon(Icons.favorite_border),
                  onPressed: likeButtonTapped);
            }),
            IconButton(
                icon: SvgPicture.asset(
                  AppImages.commentButtonSvg,
                  width: 20,
                  height: 20,
                ),
                onPressed: onCommentButtonTapped),
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
        InkWell(
          onTap: () {
            NavigationUtils.pushScreen(
                screen: SearchedUserProfileScreen(widget.post.publisherId),
                context: context);
          },
          child: Row(
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
        ),
        IconButton(onPressed: () {}, icon: Icon(Icons.more_vert))
      ],
    );
  }
}
