import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:instagramapp/src/bloc/searched_user_bloc/searched_user_bloc.dart';
import 'package:instagramapp/src/repository/data_repository.dart';
import 'package:instagramapp/src/res/app_strings.dart';
import '../../../../bloc/auth_bloc/auth_bloc.dart' as auth_bloc;
import '../../../../models/post_model/post_model.dart';
import '../../../common/small_post_view.dart';
import '../../../common/small_posts_grid_view.dart';

class SearchedUserPostsView extends StatefulWidget {
  SearchedUserPostsView({
    Key? key,
  }) : super(key: key);

  @override
  State<SearchedUserPostsView> createState() => _SearchedUserPostsViewState();
}

class _SearchedUserPostsViewState extends State<SearchedUserPostsView> {
  late SearchedUserBloc _searchedUserBloc;

  @override
  void didChangeDependencies() {
    _searchedUserBloc = context.read<SearchedUserBloc>();
    _searchedUserBloc.add(FetchSearchedUserPostsStarted());
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<SearchedUserBloc, SearchedUserState>(
        builder: (context, state) {
      if (state is SearchedUserError)
        return Text(state.error);
      else if (state is SearchedUserPostsLoading) {
        return Center(
          child: CircularProgressIndicator(),
        );
      } else if (state is SearchedUserEmptyPosts)
        return _buildEmptyOwnPosts();
      else {
        return SmallPostsGridView(_searchedUserBloc.posts);
      }
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
