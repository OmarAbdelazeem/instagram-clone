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
      } else {
        if (_searchedUserBloc.posts.isNotEmpty) {
          return SmallPostsGridView(_searchedUserBloc.posts);
        } else {
          return Center(child: SearchedUserEmptyPostsView());
        }
      }
    });
  }
}
