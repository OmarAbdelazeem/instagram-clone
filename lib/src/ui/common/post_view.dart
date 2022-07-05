import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:instagramapp/src/bloc/logged_in_user_bloc/logged_in_user_bloc.dart';
import 'package:instagramapp/src/core/utils/app_bottom_sheet.dart';
import 'package:instagramapp/src/core/utils/navigation_utils.dart';
import 'package:instagramapp/src/res/app_colors.dart';
import 'package:instagramapp/src/res/app_images.dart';
import 'package:instagramapp/src/ui/common/profile_photo.dart';
import 'package:instagramapp/src/ui/screens/comments_screen/comments_screen.dart';
import 'package:instagramapp/src/ui/screens/edit_post_screen/edit_post_screen.dart';
import '../../bloc/bottom_navigation_bar_cubit/bottom_navigation_bar_cubit.dart';
import '../../bloc/likes_bloc/likes_bloc.dart';
import '../../bloc/post_item_bloc/post_item_bloc.dart';
import '../../models/post_model/post_model_response/post_model_response.dart';
import '../../repository/data_repository.dart';
import '../../res/app_strings.dart';
import '../screens/profile_screen/searched_user_profile_screen.dart';

class PostView extends StatefulWidget {
  final PostModelResponse post;

  PostView({
    required this.post,
  });

  @override
  _PostViewState createState() => _PostViewState();
}

class _PostViewState extends State<PostView> {
  late BottomNavigationBarCubit bottomNavigationBarCubit;
  late PostItemBloc postItemBloc;
  late LoggedInUserBloc loggedInUserBloc;
  late Size mediaQuerySize;

  void _onLikeButtonTapped() {
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

  void _onCommentButtonTapped() {
    NavigationUtils.pushScreen(
        screen: CommentsScreen(widget.post, postItemBloc), context: context);
  }

  @override
  void initState() {
    postItemBloc = PostItemBloc(
        dataRepository: context.read<DataRepository>(),
        likesBloc: context.read<LikesBloc>(),
        post: widget.post);
    loggedInUserBloc = context.read<LoggedInUserBloc>();
    bottomNavigationBarCubit = context.read<BottomNavigationBarCubit>();
    postItemBloc.add(CheckIfPostStateIsChangedStarted());
    // postItemBloc.add(event)
// TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    mediaQuerySize = MediaQuery.of(context).size;
    return BlocProvider(
      create: (_) => postItemBloc,
      child: SingleChildScrollView(
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
                children: [_buildLikesCount(), _buildPublisherNameAndCaption()],
              ),
            )
          ],
        ),
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
        BlocConsumer<PostItemBloc, PostItemState>(listener: (context, state) {
          if (state is PostCaptionEdited) {
            widget.post.caption = state.caption;
          }
        }, builder: (context, state) {
          return Text(
            widget.post.caption,
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
                  icon: postItemBloc.isLiked
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
      imageUrl: widget.post.photoUrl,
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
              ProfilePhoto(photoUrl: widget.post.publisherProfilePhotoUrl),
              SizedBox(
                width: 8,
              ),
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 4),
                child: Text(widget.post.publisherName,
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
    if (widget.post.publisherId == loggedInUserBloc.loggedInUser!.id!) {
      bottomNavigationBarCubit.changeCurrentScreen(3);
    } else {
      NavigationUtils.pushScreen(
          screen: SearchedUserProfileScreen(
              searchedUserId: widget.post.publisherId),
          context: context);
    }
  }

  void onPostActionTap(String title) {
    if (title == AppStrings.edit) {
      Navigator.pop(context);
      NavigationUtils.pushScreen(
        screen: EditPostScreen(
            postResponse: widget.post, postItemBloc: postItemBloc),
        context: context,
      );
    } else if (title == AppStrings.share) {
    } else if (title == AppStrings.delete) {}
  }
}
