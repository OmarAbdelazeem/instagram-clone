import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:instagramapp/src/bloc/logged_in_user_bloc/logged_in_user_bloc.dart';
import 'package:instagramapp/src/core/utils/app_bottom_sheet.dart';
import 'package:instagramapp/src/core/utils/navigation_utils.dart';
import 'package:instagramapp/src/repository/posts_repository.dart';
import 'package:instagramapp/src/res/app_colors.dart';
import 'package:instagramapp/src/res/app_images.dart';
import 'package:instagramapp/src/ui/common/profile_photo.dart';
import 'package:instagramapp/src/ui/screens/comments_screen/comments_screen.dart';
import 'package:instagramapp/src/ui/screens/edit_post_screen/edit_post_screen.dart';
import '../../bloc/bottom_navigation_bar_cubit/bottom_navigation_bar_cubit.dart';
import '../../bloc/post_item_bloc/post_item_bloc.dart';
import '../../bloc/posts_bloc/posts_bloc.dart';
import '../../models/post_model/post_model.dart';
import '../../repository/data_repository.dart';
import '../../res/app_strings.dart';
import '../screens/profile_screen/searched_user_profile_screen.dart';

class PostView extends StatefulWidget {
  PostModel post;

  PostView({
    required this.post,
  });

  @override
  _PostViewState createState() => _PostViewState();
}

class _PostViewState extends State<PostView>
    with AutomaticKeepAliveClientMixin<PostView> {
  late BottomNavigationBarCubit bottomNavigationBarCubit;
  late PostItemBloc postItemBloc;
  late LoggedInUserBloc loggedInUserBloc;
  late Size mediaQuerySize;

  void _onLikeButtonTapped() {
    if (widget.post.isLiked!) {
      postItemBloc.add(RemoveLikeStarted(
        postId: widget.post.postId,
      ));
    } else {
      postItemBloc.add(AddLikeStarted(
        postId: widget.post.postId,
      ));
    }
  }

  void _onCommentButtonTapped() {
    NavigationUtils.pushScreen(
        screen: CommentsScreen(postItemBloc.currentPost!, postItemBloc),
        context: context);
  }

  @override
  void initState() {
    postItemBloc = PostItemBloc(
        dataRepository: context.read<DataRepository>(),
        postsBloc: context.read<PostsBloc>(),
        currentPost: widget.post);
    postItemBloc.add(ListenForPostUpdatesStarted());
    loggedInUserBloc = context.read<LoggedInUserBloc>();
    bottomNavigationBarCubit = context.read<BottomNavigationBarCubit>();
// TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    mediaQuerySize = MediaQuery.of(context).size;
    return BlocProvider<PostItemBloc>(
      create: (_) => postItemBloc,
      child: BlocConsumer<PostItemBloc, PostItemState>(
        listener: (context, state) {},
        builder: (context, state) {
          return SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Padding(
                    padding: EdgeInsets.symmetric(vertical: 4, horizontal: 8),
                    child: _buildPostHeader()),
                Center(child: _buildPostImage()),
                _buildPostActions(),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 8),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _buildLikesCount(),
                      _buildPublisherNameAndCaption()
                    ],
                  ),
                )
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildPublisherNameAndCaption() {
    return Row(
      children: <Widget>[
        Text(
          widget.post.owner!.userName!,
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        SizedBox(
          width: 5,
        ),
        BlocConsumer<PostItemBloc, PostItemState>(listener: (context, state) {
          if (state is PostCaptionEdited) {
            postItemBloc.currentPost!.caption = state.caption;
          }
        }, builder: (context, state) {
          return Text(
            postItemBloc.currentPost!.caption,
            style: TextStyle(fontSize: 16),
          );
        }),
      ],
    );
  }

  Widget _buildLikesCount() {
    return BlocBuilder<PostItemBloc, PostItemState>(
      builder: (context, state) {
        return Text(
          '${postItemBloc.currentPost!.likesCount} ${AppStrings.likes}',
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
                  icon: widget.post.isLiked!
                      ? Icon(
                          Icons.favorite,
                        )
                      : Icon(Icons.favorite_border),
                  onPressed: _onLikeButtonTapped);
            }),
            IconButton(
                icon: SvgPicture.asset(
                  AppImages.commentButtonSvg,
                  width: 20,
                  height: 20,
                ),
                onPressed: _onCommentButtonTapped),
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

  CachedNetworkImage _buildPostImage() {
    return CachedNetworkImage(
      imageUrl: postItemBloc.currentPost!.photoUrl,
      fit: BoxFit.fitWidth,
      placeholder: (context, url) => SizedBox(
          height: mediaQuerySize.height * 0.45,
          child: Center(child: CircularProgressIndicator())),
      errorWidget: (context, url, error) => Icon(Icons.error),
    );
  }

  Widget _buildPostHeader() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: <Widget>[
        InkWell(
          onTap: _onPublisherNameTapped,
          child: Row(
            children: <Widget>[
              ProfilePhoto(photoUrl: widget.post.owner!.photoUrl!),
              SizedBox(
                width: 8,
              ),
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 4),
                child: Text(widget.post.owner!.userName!,
                    style: TextStyle(fontWeight: FontWeight.bold)),
              )
            ],
          ),
        ),
        IconButton(
            onPressed: () {
              showAppBottomSheet(
                  title: "", context: context, child: _buildBottomSheetView());
            },
            icon: Icon(Icons.more_vert))
      ],
    );
  }

  Widget _buildBottomSheetView() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildTitle(AppStrings.edit),
        _buildTitle(AppStrings.share),
        _buildTitle(AppStrings.delete),
        SizedBox(
          height: 20,
        )
      ],
    );
  }

  Widget _buildTitle(String title) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.symmetric(horizontal: 12),
      child: TextButton(
          onPressed: () => onPostActionTap(title),
          child: SizedBox(
            width: double.infinity,
            child: Text(
              title,
              style: TextStyle(
                  fontSize: 18,
                  color: AppColors.black,
                  fontWeight: FontWeight.normal),
              textAlign: TextAlign.start,
            ),
          )),
    );
  }

  void _onPublisherNameTapped() {
    // 1) check if it is not logged in user
    if (postItemBloc.currentPost!.publisherId ==
        loggedInUserBloc.loggedInUser!.id!) {
      bottomNavigationBarCubit.changeCurrentScreen(3);
    } else {
      NavigationUtils.pushScreen(
          screen: SearchedUserProfileScreen(user: widget.post.owner!),
          context: context);
    }
  }

  void onPostActionTap(String title) {
    if (title == AppStrings.edit) {
      Navigator.pop(context);
      NavigationUtils.pushScreen(
        screen: EditPostScreen(
            post: postItemBloc.currentPost!, postItemBloc: postItemBloc),
        context: context,
      );
    } else if (title == AppStrings.share) {
    } else if (title == AppStrings.delete) {}
  }

  @override
  // TODO: implement wantKeepAlive
  bool get wantKeepAlive => true;
}
