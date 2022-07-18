import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:instagramapp/src/bloc/searched_user_bloc/searched_user_bloc.dart';
import 'package:instagramapp/src/repository/data_repository.dart';
import 'package:instagramapp/src/res/app_strings.dart';
import 'package:instagramapp/src/res/app_text_styles.dart';
import '../../../../bloc/auth_bloc/auth_bloc.dart' as auth_bloc;
import '../../../common/small_post_view.dart';
import '../../../common/small_posts_grid_view.dart';
import '../widgets/searched_user_empty_posts.dart';

class SearchedUserPostsView extends StatefulWidget {
  SearchedUserPostsView({
    Key? key,
  }) : super(key: key);

  @override
  State<SearchedUserPostsView> createState() => _SearchedUserPostsViewState();
}

class _SearchedUserPostsViewState extends State<SearchedUserPostsView> {
  late SearchedUserBloc _searchedUserBloc;
  late ScrollController scrollController;

  Future<void> fetchPosts(bool nextList) async {
    _searchedUserBloc.add(FetchSearchedUserPostsStarted(nextList));
  }

  void _scrollListener() {
    bool isNextPostsLoading =
        _searchedUserBloc.state is SearchedUserNextPostsLoading;
    if (scrollController.offset >= scrollController.position.maxScrollExtent &&
        !scrollController.position.outOfRange) {
      if (!isNextPostsLoading && !_searchedUserBloc.isReachedToTheEnd)
        fetchPosts(true);
    }
  }

  @override
  void initState() {
    _searchedUserBloc = context.read<SearchedUserBloc>();
    fetchPosts(false);
    scrollController = ScrollController();
    scrollController.addListener(_scrollListener);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<SearchedUserBloc, SearchedUserState>(
        builder: (context, state) {
      if (state is SearchedUserError)
        return Text(state.error);
      else if (state is SearchedUserFirstPostsLoading ||
          state is SearchedUserInitial) {
        return Center(
          child: CircularProgressIndicator(),
        );
      } else {
        if (_searchedUserBloc.posts.isEmpty) {
          return Center(child: SearchedUserEmptyPostsView());
        } else {
          return _buildPosts(state);
        }
      }
    });
  }

  Widget _buildPosts(SearchedUserState state) {
    return Column(
      children: [
        Expanded(
          child: GridView.builder(
            controller: scrollController,
            padding: EdgeInsets.zero,
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 3,
              crossAxisSpacing: 1,
              mainAxisSpacing: 1,
              mainAxisExtent: 120,
            ),
            itemCount: _searchedUserBloc.posts.length,
            itemBuilder: (BuildContext context, int index) {
              return SmallPostView(post: _searchedUserBloc.posts[index]);
            },
          ),
        ),
        SizedBox(height: 12),
        state is SearchedUserNextPostsLoading
            ? CircularProgressIndicator()
            : Container()
        // state is
      ],
    );
  }
}
