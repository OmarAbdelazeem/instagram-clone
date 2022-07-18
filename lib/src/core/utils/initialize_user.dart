import '../../models/user_model/user_model.dart';
import '../../repository/data_repository.dart';

Future<UserModel> initializeUser(
    Map<String, dynamic> data, DataRepository dataRepository) async {
  UserModel user = UserModel.fromJson(data);
  user.isFollowed =
  await dataRepository.checkIfUserFollowingSearched(receiverId: user.id!);
  return user;
}