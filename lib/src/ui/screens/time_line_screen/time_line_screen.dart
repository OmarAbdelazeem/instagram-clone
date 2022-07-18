import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:instagramapp/src/bloc/logged_in_user_bloc/logged_in_user_bloc.dart';
import 'package:instagramapp/src/bloc/post_item_bloc/post_item_bloc.dart';
import 'package:instagramapp/src/bloc/time_line_bloc/time_line_bloc.dart';
import 'package:instagramapp/src/repository/data_repository.dart';
import 'package:instagramapp/src/repository/storage_repository.dart';
import 'package:instagramapp/src/res/app_images.dart';
import 'package:instagramapp/src/ui/screens/time_line_screen/timeline_scroll_offset.dart';
import 'package:instagramapp/src/ui/screens/time_line_screen/widgets/recommended_user.dart';
import 'package:instagramapp/src/ui/screens/time_line_screen/widgets/time_line_actions_drob_down.dart';
import '../../../bloc/search_users_bloc/search_users_bloc.dart';
import '../../../bloc/users_bloc/users_bloc.dart';
import '../../../repository/posts_repository.dart';
import '../../../res/app_strings.dart';
import '../../common/app_logo.dart';
import '../../common/post_view.dart';

class TimeLineScreen extends StatefulWidget {
  final TimeLineBloc timeLineBloc;

  TimeLineScreen(this.timeLineBloc);

  @override
  _TimeLineScreenState createState() => _TimeLineScreenState();
}

class _TimeLineScreenState extends State<TimeLineScreen>
    with AutomaticKeepAliveClientMixin<TimeLineScreen> {
  late LoggedInUserBloc loggedInUserBloc;
  late UsersSearchBloc usersBloc;
  late ScrollController scrollController;

  Future fetchTimeLinePosts(bool nextList) async {
    widget.timeLineBloc.add(FetchTimeLinePostsStarted(nextList));
  }

  void _scrollListener() {
    bool isFetchingNextList = widget.timeLineBloc.state is NextTimeLineLoading;
    if (scrollController.offset >= scrollController.position.maxScrollExtent &&
        !scrollController.position.outOfRange) {
      if (!isFetchingNextList && !widget.timeLineBloc.isReachedToTheEnd)
        fetchTimeLinePosts(true);
    }
  }

  @override
  void initState() {
    loggedInUserBloc = context.read<LoggedInUserBloc>();

    final dataRepository = context.read<DataRepository>();
    scrollController = ScrollController();

    usersBloc = UsersSearchBloc(dataRepository, context.read<UsersBloc>());

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
      appBar: _buildAppBar(),
      body: MultiBlocProvider(
        providers: [
          BlocProvider<UsersSearchBloc>(
            create: (context) => usersBloc,
          ),
        ],
        child: RefreshIndicator(
          onRefresh: () => fetchTimeLinePosts(false),
          child: BlocConsumer<TimeLineBloc, TimeLineState>(
              bloc: widget.timeLineBloc,
              listener: (BuildContext context, state) {
                if (state is TimeLineLoaded &&
                    widget.timeLineBloc.posts.isEmpty) {
                  usersBloc.add(FetchRecommendedUsersStarted());
                }
              },
              builder: (BuildContext context, state) {
                if (state is FirstTimeLineLoading)
                  return Center(child: CircularProgressIndicator());
                else if (state is TimeLineError)
                  return Text(state.error);
                else if (widget.timeLineBloc.posts.isEmpty) {
                  return _buildRecommendedUsers();
                }
                return _buildTimelinePosts(state);
              }),
        ),
      ),
    );
  }

  AppBar _buildAppBar() {
    return AppBar(
      title: AppLogo(fontSize: 30),
      actions: <Widget>[
        TimelineActionsDropList(),
        IconButton(
          onPressed: () {},
          icon: SvgPicture.asset(
            AppImages.sendButtonSvg,
            width: 20,
            height: 20,
          ),
        ),
      ],
    );
  }

  _buildTimelinePosts(TimeLineState state) {
    return Column(
      children: [
        Expanded(
          child: ListView.builder(
            controller: scrollController,
            itemBuilder: (context, index) {
              return PostView(
                post: widget.timeLineBloc.posts[index],
              );
            },
            itemCount: widget.timeLineBloc.posts.length,
          ),
        ),
        SizedBox(
          height: 12,
        ),
        state is NextTimeLineLoading ? CircularProgressIndicator() : Container()
      ],
    );
  }

  _buildRecommendedUsers() {
    return BlocBuilder<UsersSearchBloc, SearchUsersState>(
      builder: (BuildContext context, state) {
        return ListView(
          children: [
            Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Text(
                  AppStrings.welcomeToInstagram,
                  style: TextStyle(
                    fontSize: 30,
                  ),
                ),
                SizedBox(
                  height: 20,
                ),
                Text(
                  AppStrings.followPeopleToStartSeeingPhotos,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 17,
                  ),
                ),
                Container(
                  height: 220,
                  child: ListView.builder(
                    shrinkWrap: true,
                    scrollDirection: Axis.horizontal,
                    itemBuilder: (context, index) {
                      return RecommendedUser(usersBloc.recommendedUsers[index]);
                    },
                    itemCount: usersBloc.recommendedUsers.length,
                  ),
                ),
              ],
            )
          ],
        );
      },
    );
  }

  @override
  // TODO: implement wantKeepAlive
  bool get wantKeepAlive => true;
}
