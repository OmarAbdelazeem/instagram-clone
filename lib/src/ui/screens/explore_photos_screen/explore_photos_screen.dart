import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:instagramapp/src/bloc/likes_bloc/likes_bloc.dart';
import 'package:instagramapp/src/bloc/logged_in_user_bloc/logged_in_user_bloc.dart';
import 'package:instagramapp/src/core/utils/navigation_utils.dart';
import 'package:instagramapp/src/repository/data_repository.dart';
import 'package:instagramapp/src/res/app_strings.dart';
import '../../../../router.dart';
import '../../../bloc/explore_posts_bloc/explore_posts_bloc.dart';
import '../../../bloc/likes_bloc/likes_bloc.dart';
import '../../../repository/data_repository.dart';
import '../../../res/app_images.dart';
import '../../common/app_text_field.dart';
import '../../common/small_posts_grid_view.dart';

class ExplorePhotosScreen extends StatefulWidget {
  @override
  _ExplorePhotosScreenState createState() => _ExplorePhotosScreenState();
}

class _ExplorePhotosScreenState extends State<ExplorePhotosScreen> {
  late ExplorePostsBloc explorePostsBloc;

  Future fetchExplorePosts() async {
    explorePostsBloc.add(FetchExplorePostsStarted());
  }

  @override
  void initState() {
    final userId = context.read<LoggedInUserBloc>().loggedInUser!.id!;
    final likesBloc = context.read<LikesBloc>();
    final dataRepository = context.read<DataRepository>();
    explorePostsBloc = ExplorePostsBloc(userId, likesBloc, dataRepository);
    fetchExplorePosts();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            _buildSearchBar(),
            BlocProvider(
              create: (_) => explorePostsBloc,
              child: BlocBuilder<ExplorePostsBloc, ExplorePostsState>(
                  builder: (context, state) {
                if (state is ExplorePostsError)
                  return Text(state.error);
                else if (state is ExplorePostsLoading) {
                  return Center(
                    child: CircularProgressIndicator(),
                  );
                } else
                  return Expanded(
                    child: RefreshIndicator(
                      onRefresh: fetchExplorePosts,
                      child: SmallPostsGridView(explorePostsBloc.posts),
                    ),
                  );
              }),
            )
          ],
        ),
      ),
    );
  }

  Widget _buildSearchBar() {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: InkWell(
        onTap: () {
          NavigationUtils.pushNamed(
              route: AppRoutes.searchScreen, context: context);
        },
        child: IgnorePointer(
          child: AppTextField(
            hintText: AppStrings.search,
            icon: SvgPicture.asset(AppImages.searchEmptySvg, height: 16),
          ),
        ),
      ),
    );
  }
}
