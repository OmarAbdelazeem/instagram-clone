import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:instagramapp/src/bloc/activities_bloc/activities_bloc.dart';
import 'package:instagramapp/src/res/app_strings.dart';
import 'package:instagramapp/src/res/app_text_styles.dart';
import 'widgets/notification_item.dart';

class ActivityScreen extends StatefulWidget {
  final ActivitiesBloc activitiesBloc;

  ActivityScreen(this.activitiesBloc);

  @override
  State<ActivityScreen> createState() => _ActivityScreenState();
}

class _ActivityScreenState extends State<ActivityScreen>
    with AutomaticKeepAliveClientMixin<ActivityScreen> {
  late ScrollController scrollController;

  Future<void> fetchActivities(bool nextList) async {
    widget.activitiesBloc.add(FetchActivitiesStarted(nextList));
  }

  void _scrollListener() {
    bool isFetchingNextList =
        widget.activitiesBloc.state is NextActivitiesLoading;
    if (scrollController.offset >= scrollController.position.maxScrollExtent &&
        !scrollController.position.outOfRange) {
      if (!isFetchingNextList && !widget.activitiesBloc.isReachedToTheEnd)
        fetchActivities(true);
    }
  }

  @override
  void initState() {
    scrollController = ScrollController();

    scrollController.addListener(_scrollListener);
    // TODO: implement initState
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
      body: BlocProvider(
        create: (_) => widget.activitiesBloc,
        child: RefreshIndicator(
          onRefresh: () => fetchActivities(false),
          child: BlocBuilder<ActivitiesBloc, ActivitiesState>(
              builder: (context, state) {
            if (state is FirstActivitiesLoading)
              return Center(
                child: CircularProgressIndicator(),
              );
            else if (state is ActivitiesError)
              return Text(state.error);
            else {
              if (widget.activitiesBloc.activities.isNotEmpty) {
                return _buildNotifications(state);
              } else {
                return _buildEmptyView();
              }
            }
          }),
        ),
      ),
    );
  }

  AppBar _buildAppBar() {
    return AppBar(
      title: Text(
        AppStrings.activity,
        style: AppTextStyles.appBarTitleStyle,
      ),
    );
  }

  Widget _buildNotifications(ActivitiesState state) {
    return Column(
      children: [
        Expanded(
          child: ListView.builder(
            controller: scrollController,
            itemBuilder: (context, index) =>
                NotificationItem(widget.activitiesBloc.activities[index]),
            itemCount: widget.activitiesBloc.activities.length,
          ),
        ),
        state is NextActivitiesLoading
            ? CircularProgressIndicator()
            : Container()
      ],
    );
  }

  Widget _buildEmptyView() {
    return ListView(
      children: [Container()],
    );
  }

  @override
  // TODO: implement wantKeepAlive
  bool get wantKeepAlive => true;
}
