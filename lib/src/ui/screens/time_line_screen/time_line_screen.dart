import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:instagramapp/src/bloc/logged_in_user_bloc/logged_in_user_bloc.dart';
import 'package:instagramapp/src/bloc/time_line_bloc/time_line_bloc.dart';
import 'package:instagramapp/src/core/saved_posts_likes.dart';
import 'package:instagramapp/src/core/utils/navigation_utils.dart';
import 'package:instagramapp/src/models/post_model/post_model.dart';
import 'package:instagramapp/src/repository/data_repository.dart';
import 'package:instagramapp/src/repository/storage_repository.dart';
import 'package:instagramapp/src/res/app_images.dart';
import 'package:instagramapp/src/ui/screens/time_line_screen/widgets/recommended_user.dart';
import 'package:instagramapp/src/ui/screens/time_line_screen/widgets/time_line_actions_drob_down.dart';
import '../../../../router.dart';
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
  List<UserModel> users = [
    UserModel(
        photoUrl:
            "https://media.wired.com/photos/5fb70f2ce7b75db783b7012c/master/pass/Gear-Photos-597589287.jpg",
        userName: "Omar Abdelazeem",
        bio: "this is a bio",
        id: "123",
        email: "omar@email.com",
        postsCount: 1,
        followersCount: 3,
        followingCount: 5,
        timestamp: (Timestamp.now()).toDate()),
    UserModel(
        photoUrl:
            "https://media.wired.com/photos/5fb70f2ce7b75db783b7012c/master/pass/Gear-Photos-597589287.jpg",
        userName: "Omar Abdelazeem",
        bio: "this is a bio",
        id: "123",
        email: "omar@email.com",
        postsCount: 1,
        followersCount: 3,
        followingCount: 5,
        timestamp: (Timestamp.now()).toDate()),
    UserModel(
        photoUrl:
            "https://media.wired.com/photos/5fb70f2ce7b75db783b7012c/master/pass/Gear-Photos-597589287.jpg",
        userName: "Omar Abdelazeem",
        bio: "this is a bio",
        id: "123",
        email: "omar@email.com",
        postsCount: 1,
        followersCount: 3,
        followingCount: 5,
        timestamp: (Timestamp.now()).toDate())
  ];

  @override
  void didChangeDependencies() {
    timeLineBloc = TimeLineBloc(
      context.read<DataRepository>(),
        context.read<OfflineLikesRepository>()
    );
    loggedInUserBloc = context.read<LoggedInUserBloc>();
    timeLineBloc
        .add(FetchTimeLinePostsStarted(loggedInUserBloc.loggedInUser!.id!));
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _buildAppBar(),
      body: BlocProvider<TimeLineBloc>(
        create: (context) => timeLineBloc,
        child: RefreshIndicator(
          onRefresh: () => getTimeLinePosts(),
          child: BlocBuilder<TimeLineBloc, TimeLineState>(
              builder: (BuildContext context, state) {
            print("state is $state");
            if (state is TimeLineLoaded) {
              final timelinePosts = timeLineBloc.posts;
              if (timelinePosts.isNotEmpty)
                return _buildTimelinePosts(timelinePosts);
              else
                return _buildRecommendedUsers();
            } else if (state is TimeLineError)
              return Text(state.error);
            else
              return Center(
                child: CircularProgressIndicator(),
              );
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

  Future getTimeLinePosts() async {
    timeLineBloc
        .add(FetchTimeLinePostsStarted(loggedInUserBloc.loggedInUser!.id!));
  }

  _buildTimelinePosts(List<PostModel> timelinePosts) {
    return ListView.builder(
      shrinkWrap: true,
      itemBuilder: (context, index) => PostView(
        post: timelinePosts[index],
      ),
      itemCount: timelinePosts.length,
    );
  }

  _buildRecommendedUsers() {
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: <Widget>[
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
              return RecommendedUser(users[index]);
            },
            itemCount: users.length,
          ),
        ),
      ],
    );
  }
}
