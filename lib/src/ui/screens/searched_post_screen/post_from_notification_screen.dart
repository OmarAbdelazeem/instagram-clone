import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:instagramapp/src/bloc/post_item_bloc/post_item_bloc.dart';
import 'package:instagramapp/src/repository/data_repository.dart';
import 'package:instagramapp/src/repository/posts_repository.dart';
import '../../../bloc/posts_bloc/posts_bloc.dart';
import '../../../res/app_strings.dart';
import '../../../res/app_text_styles.dart';
import '../../common/post_view.dart';

class PostFromNotificationScreen extends StatefulWidget {
  final String postId;

  const PostFromNotificationScreen({Key? key, required this.postId})
      : super(key: key);

  @override
  _PostFromNotificationScreenState createState() =>
      _PostFromNotificationScreenState();
}

class _PostFromNotificationScreenState
    extends State<PostFromNotificationScreen> {
  late PostItemBloc postItemBloc;

  @override
  void initState() {
    postItemBloc = PostItemBloc(
      dataRepository: context.read<DataRepository>(),
      postsBloc: context.read<PostsBloc>(),
    );

    postItemBloc.add(FetchPostDetailsStarted(widget.postId));
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _buildAppBar(),
      body: BlocProvider<PostItemBloc>(
        create: (_) => postItemBloc,
        child:
            BlocBuilder<PostItemBloc, PostItemState>(builder: (context, state) {
          print("state is $state");
          if (state is PostLoading || state is PostItemInitial) {
            return Center(
              child: CircularProgressIndicator(),
            );
          } else if (state is PostItemError)
            return Center(
              child: Text(state.error),
            );
          return PostView(
            post: postItemBloc.currentPost!,
          );
        }),
      ),
    );
  }

  AppBar _buildAppBar() {
    return AppBar(
      title: Text(AppStrings.post, style: AppTextStyles.appBarTitleStyle),
    );
  }
}
