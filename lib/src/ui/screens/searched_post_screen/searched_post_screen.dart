import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../bloc/posts_bloc/posts_bloc.dart';

class SearchedPostScreen extends StatefulWidget {
  final String postId;
  final String userId;

  const SearchedPostScreen(
      {Key? key, required this.postId, required this.userId})
      : super(key: key);

  @override
  _SearchedPostScreenState createState() => _SearchedPostScreenState();
}

class _SearchedPostScreenState extends State<SearchedPostScreen> {
  @override
  void initState() {
    context.read<PostsBloc>().add(
        PostDetailsLoadStarted(postId: widget.postId, userId: widget.userId));
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container();
  }
}
