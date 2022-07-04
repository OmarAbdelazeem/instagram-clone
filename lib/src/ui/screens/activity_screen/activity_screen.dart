import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:instagramapp/src/bloc/activities_bloc/activities_bloc.dart';
import 'package:instagramapp/src/repository/data_repository.dart';
import 'package:instagramapp/src/res/app_strings.dart';
import 'package:instagramapp/src/res/app_text_styles.dart';
import 'widgets/notification_item.dart';

class ActivityScreen extends StatefulWidget {
  @override
  State<ActivityScreen> createState() => _ActivityScreenState();
}

class _ActivityScreenState extends State<ActivityScreen> {
  late ActivitiesBloc activitiesBloc;

  Future<void> fetchActivities() async {
    activitiesBloc.add(FetchActivitiesStarted());
  }

  @override
  void initState() {
    activitiesBloc = ActivitiesBloc(context.read<DataRepository>());
    fetchActivities();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _buildAppBar(),
      body: _buildNotifications(),
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

  Widget _buildNotifications() {
    return BlocBuilder<ActivitiesBloc, ActivitiesState>(
        bloc: activitiesBloc,
        builder: (context, state) {
          if (state is ActivitiesLoading)
            return Center(
              child: CircularProgressIndicator(),
            );
          else if (state is ActivitiesError) return Text(state.error);
          return RefreshIndicator(
            onRefresh: fetchActivities,
            child: ListView.builder(
              itemBuilder: (context, index) =>
                  NotificationItem(activitiesBloc.notifications[index]),
              itemCount: activitiesBloc.notifications.length,
            ),
          );
        });
  }
}
