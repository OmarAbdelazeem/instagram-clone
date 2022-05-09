import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:instagramapp/src/bloc/logged_in_user_bloc/logged_in_user_bloc.dart';
import 'package:instagramapp/src/res/app_strings.dart';
import '../../../../bloc/auth_bloc/auth_bloc.dart' as auth_bloc;
import '../../../../bloc/posts_bloc/posts_bloc.dart';
import '../../../../models/post_model/post_model.dart';


class UserOwnPostsView extends StatefulWidget {
  final String userId;

  UserOwnPostsView({Key? key, required this.userId}) : super(key: key);

  @override
  State<UserOwnPostsView> createState() => _UserOwnPostsViewState();
}

class _UserOwnPostsViewState extends State<UserOwnPostsView> {
  PostsBloc? postsBloc;
  bool? isForLoggedInUser;

  @override
  void initState() {
    isForLoggedInUser =
        context.read<LoggedInUserBloc>().loggedInUser!.id == widget.userId;
    postsBloc = context.read<PostsBloc>();
    postsBloc!.add(FetchUserPostsStarted(widget.userId));
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;

    final double itemHeight = (size.height - kToolbarHeight - 24) / 4;
    final double itemWidth = size.width / 2;

    return BlocBuilder(
        builder: (context, state) {
          if (state is Error)
            return Text(state.error);
          else if (state is PostsLoaded) {
            return state.posts.isNotEmpty
                ? _buildOwnPosts(
                    posts: isForLoggedInUser!
                        ? postsBloc!.loggedInUserPosts
                        : postsBloc!.searchedUserPosts,
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
