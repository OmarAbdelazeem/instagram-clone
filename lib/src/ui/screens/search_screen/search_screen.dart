import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:instagramapp/src/bloc/logged_in_user_bloc/logged_in_user_bloc.dart';
import 'package:instagramapp/src/bloc/users_bloc/users_bloc.dart';
import 'package:instagramapp/src/repository/auth_repository.dart';
import 'package:instagramapp/src/repository/data_repository.dart';
import 'package:instagramapp/src/res/app_colors.dart';
import 'package:instagramapp/src/res/app_images.dart';
import 'package:instagramapp/src/ui/common/app_text_field.dart';
import 'package:instagramapp/src/ui/screens/search_screen/widgets/search_result.dart';

import '../../../res/app_strings.dart';

class SearchScreen extends StatefulWidget {
  const SearchScreen({Key? key}) : super(key: key);

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  final TextEditingController searchController = TextEditingController();
  late UsersBloc usersBloc;

  @override
  void initState() {
    usersBloc = UsersBloc(context.read<DataRepository>(),
        context.read<LoggedInUserBloc>().loggedInUser!.id!);
    searchController.addListener(() {
      usersBloc.add(SearchByTermEventStarted(term: searchController.text));
    });

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _buildAppBar(),
      body: _buildUsersContent(),
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
    return BlocProvider<UsersBloc>(
      create: (_) => usersBloc,
      child: BlocBuilder<UsersBloc, UsersState>(
          bloc: usersBloc,
          builder: (BuildContext context, state) {
            if (state is UsersLoaded)
              return ListView.builder(
                itemBuilder: (context, index) {
                  return SearchResult(state.users[index]);
                },
                itemCount: state.users.length,
              );
            else if (state is UsersLoading)
              return Center(
                child: CircularProgressIndicator(),
              );
            else if (state is Error)
              return Center(
                child: Text(AppStrings.error),
              );
            else
              return Container();
          }),
    );
  }
}
