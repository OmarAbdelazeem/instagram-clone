import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:instagramapp/src/bloc/logged_in_user_bloc/logged_in_user_bloc.dart';
import 'package:instagramapp/src/bloc/time_line_bloc/time_line_bloc.dart';
import 'package:instagramapp/src/bloc/users_bloc/users_bloc.dart';
import 'package:instagramapp/src/core/saved_posts_likes.dart';
import 'package:instagramapp/src/core/utils/navigation_utils.dart';
import 'package:instagramapp/src/models/post_model/post_model.dart';
import 'package:instagramapp/src/repository/data_repository.dart';
import 'package:instagramapp/src/repository/storage_repository.dart';
import 'package:instagramapp/src/res/app_images.dart';
import 'package:instagramapp/src/ui/screens/time_line_screen/widgets/recommended_user.dart';
import 'package:instagramapp/src/ui/screens/time_line_screen/widgets/time_line_actions_drob_down.dart';
import '../../../../router.dart';
import '../../../bloc/likes_bloc/likes_bloc.dart';
import '../../../bloc/posts_bloc/posts_bloc.dart';
import '../../../models/user_model/user_model.dart';
import '../../../models/viewed_post_model/viewed_post_model.dart';
import '../../../repository/auth_repository.dart';
import '../../../res/app_strings.dart';
import '../../common/app_logo.dart';
import '../../common/post_view.dart';

class TimeLineScreen extends StatefulWidget {
  @override
  _TimeLineScreenState createState() => _TimeLineScreenState();
}

class _TimeLineScreenState extends State<TimeLineScreen> {
  late TimeLineBloc timeLineBloc;
  late LoggedInUserBloc loggedInUserBloc;
  late UsersBloc usersBloc;

  Future getTimeLinePosts() async {
    timeLineBloc
        .add(FetchTimeLinePostsStarted(loggedInUserBloc.loggedInUser!.id!));
  }

  @override
  void didChangeDependencies() {
    final dataRepository = context.read<DataRepository>();
    timeLineBloc = TimeLineBloc(
      dataRepository,
      context.read<LikesBloc>(),
    );
    loggedInUserBloc = context.read<LoggedInUserBloc>();
    timeLineBloc
        .add(FetchTimeLinePostsStarted(loggedInUserBloc.loggedInUser!.id!));
    usersBloc = UsersBloc(dataRepository, loggedInUserBloc.loggedInUser!.id!);
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _buildAppBar(),
      body: MultiBlocProvider(
        providers: [
          BlocProvider<TimeLineBloc>(
            create: (context) => timeLineBloc,
          ),
          BlocProvider<UsersBloc>(
            create: (context) => usersBloc,
          ),
        ],
        child: RefreshIndicator(
          onRefresh: () => getTimeLinePosts(),
          child: BlocConsumer<TimeLineBloc, TimeLineState>(
              listener: (BuildContext context, state) {
            if (state is EmptyTimeline) {
              usersBloc.add(FetchRecommendedUsersStarted());
            }
          }, builder: (BuildContext context, state) {
            if (state is TimeLineLoading)
              return Center(child: CircularProgressIndicator());
            else if (state is EmptyTimeline)
              return _buildRecommendedUsers();
            else if (state is TimeLineError)
              return Text(state.error);
            else
              return _buildTimelinePosts(timeLineBloc.posts);
          }),
        ),
      ),
    );
  }

  AppBar _buildAppBar() {
    return AppBar(
      title: AppLogo(fontSize: 30),
      actions: <Widget>[
        TimelineActionsDropDown(),
        SizedBox(
          width: 12,
        ),
        IconButton(
          onPressed: () {
            NavigationUtils.pushNamed(
                route: AppRoutes.activityScreen, context: context);
          },
          icon: Icon(Icons.favorite_outline),
        ),
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

  _buildTimelinePosts(List<PostModel> timelinePosts) {
    return ListView.builder(
      itemBuilder: (context, index) => PostView(
        post: timelinePosts[index],
      ),
      itemCount: timelinePosts.length,
    );
  }

  _buildRecommendedUsers() {
    return BlocBuilder<UsersBloc, UsersState>(
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
                  height: 250,
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
}
