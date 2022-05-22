import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:instagramapp/src/bloc/logged_in_user_bloc/logged_in_user_bloc.dart';
import 'package:instagramapp/src/bloc/searched_user_bloc/searched_user_bloc.dart';
import 'package:instagramapp/src/res/app_strings.dart';
import '../../../../bloc/auth_bloc/auth_bloc.dart' as auth_bloc;
import '../../../../models/post_model/post_model.dart';
import '../../../common/small_post_view.dart';

class SearchedUserPostsView extends StatefulWidget {
  SearchedUserPostsView({
    Key? key,
  }) : super(key: key);

  @override
  State<SearchedUserPostsView> createState() => _SearchedUserPostsViewState();
}

class _SearchedUserPostsViewState extends State<SearchedUserPostsView> {
  SearchedUserBloc? _searchedUserBloc;

  @override
  void initState() {
    _searchedUserBloc = context.read<SearchedUserBloc>();
    _searchedUserBloc!.add(FetchSearchedUserPostsStarted());
    // postsBloc!.add(FetchUserPostsStarted());
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
          else if (state is LoggedInUserPostsLoaded) {
            return state.posts.isNotEmpty
                ? _buildOwnPosts(
                posts: _searchedUserBloc!.posts,
                itemHeight: itemHeight,
                itemWidth: itemWidth)
                : _buildEmptyOwnPosts();
          } else
            return Center(
              child: CircularProgressIndicator(),
            );
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

  Widget _buildOwnPosts(
      {required List<PostModel> posts,
        required double itemHeight,
        required double itemWidth}) {
    return GridView.builder(
      padding: EdgeInsets.zero,
      shrinkWrap: true,
      itemCount: posts.length,
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 3,
        mainAxisSpacing: 5,
        childAspectRatio: 0.6 / 0.8,
      ),
      itemBuilder: (context, index) {
        return SmallPostView(post: posts[index]);
      },
    );
  }
}
