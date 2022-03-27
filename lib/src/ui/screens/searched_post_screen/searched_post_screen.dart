import 'package:flutter/material.dart';
import 'package:instagramapp/src/bloc/time_line_bloc/time_line_bloc.dart';
import 'package:provider/provider.dart';

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
    context.read<TimeLineBloc>().add(
        FetchPostDetailsStarted(postId: widget.postId, userId: widget.userId));
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container();
  }
}
