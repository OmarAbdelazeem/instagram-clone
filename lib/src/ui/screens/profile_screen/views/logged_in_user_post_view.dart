import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:instagramapp/src/bloc/logged_in_user_bloc/logged_in_user_bloc.dart';
import 'package:instagramapp/src/res/app_strings.dart';
import '../../../../models/post_model/post_model.dart';
import '../../../common/small_post_view.dart';
import '../../../common/small_posts_grid_view.dart';

class LoggedInUserPostsView extends StatefulWidget {
  LoggedInUserPostsView({
    Key? key,
  }) : super(key: key);

  @override
  State<LoggedInUserPostsView> createState() => _LoggedInUserPostsViewState();
}

class _LoggedInUserPostsViewState extends State<LoggedInUserPostsView> {
  LoggedInUserBloc? _loggedInUserBloc;

  @override
  void initState() {
    _loggedInUserBloc = context.read<LoggedInUserBloc>();
    _loggedInUserBloc!.add(FetchLoggedInUserPostsStarted());
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;

    final double itemHeight = (size.height - kToolbarHeight - 24) / 4;
    final double itemWidth = size.width / 2;

    return BlocBuilder<LoggedInUserBloc, LoggedInUserState>(
        builder: (context, state) {
      if (state is LoggedInUserError)
        return Text(state.error);
      else if (state is LoggedInUserPostsLoading) {
        return Center(
          child: CircularProgressIndicator(),
        );
      } else
        return _loggedInUserBloc!.posts.isNotEmpty
            ? SmallPostsGridView(_loggedInUserBloc!.posts)
            : _buildEmptyOwnPosts();
    });
  }

  Widget _buildEmptyOwnPosts() {
    return Column(
      children: <Widget>[
        Text(
          AppStrings.profile,
          style: TextStyle(fontSize: 30),
        ),
        SizedBox(
          height: 15,
        ),
        Text(
          AppStrings.whenYouSharePhotosAndVideosTheyWillAppear,
          style: TextStyle(fontSize: 16),
          overflow: TextOverflow.clip,
          textAlign: TextAlign.center,
        ),
        SizedBox(
          height: 15,
        ),
        GestureDetector(
          onTap: () {},
          child: Text(
            AppStrings.shareYourFirstPhotoOrVideo,
            style: TextStyle(
                fontSize: 16, color: Colors.blue, fontWeight: FontWeight.bold),
            overflow: TextOverflow.clip,
            textAlign: TextAlign.center,
          ),
        ),
      ],
    );
  }


}
