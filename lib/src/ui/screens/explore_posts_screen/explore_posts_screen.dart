import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:instagramapp/src/bloc/logged_in_user_bloc/logged_in_user_bloc.dart';
import 'package:instagramapp/src/core/utils/navigation_utils.dart';
import 'package:instagramapp/src/repository/data_repository.dart';
import 'package:instagramapp/src/res/app_strings.dart';
import '../../../../router.dart';
import '../../../bloc/explore_posts_bloc/explore_posts_bloc.dart';
import '../../../repository/data_repository.dart';
import '../../../res/app_images.dart';
import '../../common/app_text_field.dart';
import '../../common/small_post_view.dart';
import '../../common/small_posts_grid_view.dart';

class ExplorePostsScreen extends StatefulWidget {
  final ExplorePostsBloc explorePostsBloc;

  ExplorePostsScreen(this.explorePostsBloc);

  @override
  _ExplorePostsScreenState createState() => _ExplorePostsScreenState();
}

class _ExplorePostsScreenState extends State<ExplorePostsScreen>
    with AutomaticKeepAliveClientMixin<ExplorePostsScreen> {
  late ScrollController scrollController;

  Future fetchExplorePosts(bool nextList) async {
    widget.explorePostsBloc.add(FetchExplorePostsStarted(nextList));
  }

  void _scrollListener() {
    bool nextExplorePostsLoading =
        widget.explorePostsBloc.state is NextExplorePostsLoading;
    if (scrollController.offset >= scrollController.position.maxScrollExtent &&
        !scrollController.position.outOfRange) {
      if (!nextExplorePostsLoading &&
          !widget.explorePostsBloc.isReachedToTheEnd) {
        fetchExplorePosts(true);
      }
    }
  }

  @override
  void initState() {
    scrollController = ScrollController();
    scrollController.addListener(_scrollListener);
    super.initState();
  }

  @override
  void dispose() {
    scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            _buildSearchBar(),
            Expanded(
              child: BlocProvider(
                create: (_) => widget.explorePostsBloc,
                child: RefreshIndicator(
                  onRefresh: () => fetchExplorePosts(false),
                  child: BlocBuilder<ExplorePostsBloc, ExplorePostsState>(
                      builder: (context, state) {
                    if (state is ExplorePostsError) {
                      return _buildErrorView(state.error);
                    } else if (state is FirstExplorePostsLoading) {
                      return _buildLoadingView();
                    } else if (widget
                        .explorePostsBloc.explorePosts.isNotEmpty) {
                      return _buildExplorePostsView(state);
                    }
                    return _buildEmptyView();
                  }),
                ),
              ),
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

  Widget _buildLoadingView() {
    return Center(
      child: CircularProgressIndicator(),
    );
  }

  Widget _buildErrorView(String error) {
    return Text(error);
  }

  Widget _buildEmptyView() {
    return Container();
  }

  _buildExplorePostsView(ExplorePostsState state) {
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
            itemCount: widget.explorePostsBloc.explorePosts.length,
            itemBuilder: (BuildContext context, int index) {
              return SmallPostView(
                  post: widget.explorePostsBloc.explorePosts[index]);
            },
          ),
        ),
        SizedBox(
          height: 12,
        ),
        state is NextExplorePostsLoading
            ? CircularProgressIndicator()
            : Container()
      ],
    );
  }

  @override
  // TODO: implement wantKeepAlive
  bool get wantKeepAlive => true;
}
