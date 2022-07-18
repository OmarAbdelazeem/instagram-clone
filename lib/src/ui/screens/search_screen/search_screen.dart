import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:instagramapp/src/repository/data_repository.dart';
import 'package:instagramapp/src/res/app_colors.dart';
import 'package:instagramapp/src/res/app_images.dart';
import 'package:instagramapp/src/ui/common/app_text_field.dart';
import 'package:instagramapp/src/ui/screens/search_screen/widgets/search_result.dart';

import '../../../bloc/search_users_bloc/search_users_bloc.dart';
import '../../../bloc/users_bloc/users_bloc.dart';
import '../../../models/user_model/user_model.dart';
import '../../../res/app_strings.dart';

class SearchScreen extends StatefulWidget {
  const SearchScreen({Key? key}) : super(key: key);

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  final TextEditingController searchController = TextEditingController();
  late UsersSearchBloc usersSearchBloc;
  late ScrollController scrollController;

  Future<void> fetchSearchedUsers(bool nextList) async {
    usersSearchBloc.add(SearchByTermEventStarted(
        nextList: nextList, term: searchController.text));
  }

  @override
  void initState() {
    usersSearchBloc = UsersSearchBloc(
        context.read<DataRepository>(), context.read<UsersBloc>());
    searchController.addListener(() {
      fetchSearchedUsers(false);
    });

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _buildAppBar(),
      body: BlocProvider<UsersSearchBloc>(
        create: (_) => usersSearchBloc,
        child: _buildUsersContent(),
      ),
    );
  }

  AppBar _buildAppBar() {
    return AppBar(
      backgroundColor: AppColors.scaffoldBackgroundColor,
      automaticallyImplyLeading: false,
      title: AppTextField(
        controller: searchController,
        hintText: AppStrings.search,
        icon: SvgPicture.asset(AppImages.searchEmptySvg, height: 16),
      ),
    );
  }

  Widget _buildUsersContent() {
    return BlocBuilder<UsersSearchBloc, SearchUsersState>(
        builder: (BuildContext context, state) {
      if (state is SearchedUsersLoaded && searchController.text.isNotEmpty) {
        return _buildSearchResults(state, state.users);
      } else if (state is SearchedUsersLoading)
        return Center(
          child: CircularProgressIndicator(),
        );
      else if (state is Error)
        return _buildErrorView();
      else
        return Container();
    });
  }

  Widget _buildErrorView() {
    return Center(
      child: Text(AppStrings.error),
    );
  }

  Widget _buildSearchResults(SearchUsersState state, List<UserModel> users) {
    return Column(
      children: [
        Expanded(
          child: ListView.builder(
            // controller: scrollController,
            itemBuilder: (context, index) {
              return SearchResult(users[index]);
            },
            itemCount: users.length,
          ),
        ),
        SizedBox(
          height: 12,
        ),
      ],
    );
  }
}
