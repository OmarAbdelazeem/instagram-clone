import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:instagramapp/src/bloc/post_item_bloc/post_item_bloc.dart';
import 'package:instagramapp/src/models/comment_model/comment_model.dart';
import 'package:instagramapp/src/models/post_model/post_model.dart';
import 'package:instagramapp/src/res/app_colors.dart';
import 'package:instagramapp/src/ui/common/app_text_field.dart';
import 'package:instagramapp/src/ui/common/profile_photo.dart';
import 'package:instagramapp/src/ui/screens/comments_screen/widgets/comment_view.dart';
import 'package:instagramapp/src/ui/screens/comments_screen/widgets/no_comments_yet.dart';
import 'package:uuid/uuid.dart';

import '../../../core/utils/navigation_utils.dart';
import '../../../res/app_strings.dart';
import '../../common/timestamp_view.dart';
import '../profile_screen/searched_user_profile_screen.dart';

class CommentsScreen extends StatefulWidget {
  final PostModel post;
  final PostItemBloc postItemBloc;

  CommentsScreen(this.post, this.postItemBloc);

  @override
  _CommentsScreenState createState() => _CommentsScreenState();
}

class _CommentsScreenState extends State<CommentsScreen> {
  TextEditingController commentController = TextEditingController();

  void onPostButtonTapped() {
    if (commentController.text.isNotEmpty) {
      final CommentModel comment = CommentModel(
          commentId: Uuid().v4(),
          comment: commentController.text,
          publisherId: widget.post.publisherId,
          publisherName: widget.post.publisherName,
          postId: widget.post.postId,
          postUrl: widget.post.photoUrl,
          timestamp: Timestamp.now().toDate(),
          publisherPhotoUrl: widget.post.publisherProfilePhotoUrl);
      widget.postItemBloc.add(AddCommentStarted(comment: comment));
      commentController.clear();
    }
  }

  @override
  void initState() {
    widget.postItemBloc.add(LoadCommentsStarted(widget.post.postId));

    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _buildAppBar(),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          Expanded(child: _buildCaptionWithComments()),
          _buildCommentTextField()
        ],
      ),
    );
  }

  Widget _buildNoCommentsYet() {
    return Column(
      children: [
        SizedBox(height: MediaQuery.of(context).size.height * 0.35),
        NoCommentsYetView(),
      ],
    );
  }

  Widget _buildCaptionWithComments() {
    return Column(
      // crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        widget.post.caption.isNotEmpty ? _buildPostCaption() : Container(),
        widget.post.caption.isNotEmpty
            ? SizedBox(
                height: 8,
              )
            : Container(),
        BlocBuilder<PostItemBloc, PostItemState>(
          bloc: widget.postItemBloc,
          builder: (_, state) {
            if (state is CommentsLoading)
              return Center(
                child: CircularProgressIndicator(),
              );
            else if (widget.postItemBloc.comments.isEmpty) {
              return _buildNoCommentsYet();
            }

            return Expanded(child: _buildComments(state));
          },
        ),
      ],
    );
  }

  Widget _buildPostCaption() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        InkWell(
          onTap: () {
            NavigationUtils.pushScreen(
                screen: SearchedUserProfileScreen(
                    searchedUserId: widget.post.publisherId),
                context: context);
          },
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 4, horizontal: 10),
            child: Row(
              children: <Widget>[
                ProfilePhoto(photoUrl: widget.post.publisherProfilePhotoUrl),
                SizedBox(
                  width: 5,
                ),
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
          ),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 10),
          child: TimeStampView(widget.post.timestamp),
        ),
        SizedBox(
          height: 8,
        ),
        Divider(),
      ],
    );
  }

  Widget _buildComments(PostItemState state) {
    return ListView.builder(
      itemBuilder: (_, index) => CommentView(
          comment: widget.postItemBloc.comments[index],
          isUploaded: state is AddingComment &&
              state.commentId == widget.postItemBloc.comments[index].commentId),
      itemCount: widget.postItemBloc.comments.length,
    );
  }

  Widget _buildCommentTextField() {
    return Column(
      children: [
        Divider(),
        AppTextField(
            fillColor: AppColors.scaffoldBackgroundColor,
            hintText: AppStrings.addAComment,
            controller: commentController,
            icon: ProfilePhoto(radius: 20),
            suffixIcon: TextButton(
              child: Text(AppStrings.post, style: TextStyle(color: AppColors.blue)),
              onPressed: onPostButtonTapped,
            ))
      ],
    );
  }

  AppBar _buildAppBar() {
    return AppBar(
      title: Text(
        AppStrings.comments,
        style: TextStyle(
          color: Colors.black,
          fontWeight: FontWeight.bold,
          fontSize: 20,
        ),
      ),
    );
  }
}
