import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:instagramapp/src/bloc/post_item_bloc/post_item_bloc.dart';
import 'package:instagramapp/src/models/comment_model/comment_model.dart';
import 'package:instagramapp/src/models/post_model/post_model.dart';
import 'package:instagramapp/src/repository/data_repository.dart';
import 'package:instagramapp/src/res/app_colors.dart';
import 'package:instagramapp/src/ui/common/app_text_field.dart';
import 'package:instagramapp/src/ui/common/profile_photo.dart';
import 'package:instagramapp/src/ui/screens/comments_screen/widgets/comment_view.dart';
import 'package:uuid/uuid.dart';

import '../../../res/app_strings.dart';

class CommentsScreen extends StatefulWidget {
  final PostModel post;
  final PostItemBloc postItemBloc;

  CommentsScreen(this.post, this.postItemBloc);

  @override
  _CommentsScreenState createState() => _CommentsScreenState();
}

class _CommentsScreenState extends State<CommentsScreen> {
  TextEditingController commentController = TextEditingController();

  // List<CommentWidget> comments = [
  //   CommentWidget(
  //     postCaption: "test",
  //     postName: "test",
  //     postPhotoUrl:
  //         "https://media.wired.com/photos/5fb70f2ce7b75db783b7012c/master/pass/Gear-Photos-597589287.jpg",
  //     timestamp: Timestamp.now(),
  //   )
  // ];

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
      body: Container(
        padding: const EdgeInsets.all(8.0),
        height: double.infinity,
        child: Column(
          children: <Widget>[
            _buildPostCaption(),
            Expanded(child: _buildComments()),
            _buildCommentTextField()
          ],
        ),
      ),
    );
  }

  Widget _buildPostCaption() {
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

  Widget _buildComments() {
    return BlocBuilder<PostItemBloc, PostItemState>(
      bloc: widget.postItemBloc,
      builder: (_, state) {
        print("state is $state");
        // if (state is CommentsLoaded)

        if (state is CommentsLoading)
          return Center(
            child: CircularProgressIndicator(),
          );

        return ListView.builder(
          itemBuilder: (_, index) => CommentView(
              comment: widget.postItemBloc.comments[index],
              isUploaded: state is AddingComment &&
                  state.commentId == widget.postItemBloc.comments[index].commentId),
          itemCount: widget.postItemBloc.comments.length,
        );
      },
    );
  }

  Widget _buildCommentTextField() {
    return AppTextField(
      controller: commentController,
      icon: ProfilePhoto(radius: 20),
      suffixIcon: TextButton(
          child:
              Text(AppStrings.post, style: TextStyle(color: AppColors.black)),
          onPressed: onPostButtonTapped),
    );
  }

  AppBar _buildAppBar() {
    return AppBar(
      title: Text(
        AppStrings.comments,
        style: TextStyle(color: Colors.black),
      ),
      actions: <Widget>[
        Icon(Icons.more_vert),
      ],
    );
  }
}
