import 'package:instagramapp/src/core/utils/initialize_post.dart';
import 'package:instagramapp/src/core/utils/initialize_user.dart';
import 'package:instagramapp/src/repository/data_repository.dart';

import '../../models/notification_model/notification_model.dart';
import '../../models/user_model/user_model.dart';

Future<NotificationModel> initializeActivity(
    Map<String, dynamic> data, DataRepository dataRepository) async {
  final NotificationModel notification = NotificationModel.fromJson(data);

  final userData = (await dataRepository.getUserDetails(notification.userId))
      .data() as Map<String, dynamic>;
  final user = await initializeUser(userData, dataRepository);
  notification.user = user;
  if (notification.postId != null) {
    var postData =
        (await dataRepository.getPostDetails(postId: notification.postId!))!
            .data() as Map<String, dynamic>;
    notification.post =await initializePost(postData, dataRepository);
  }
  return notification;
}
