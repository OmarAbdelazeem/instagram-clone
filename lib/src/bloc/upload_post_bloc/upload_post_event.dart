part of 'upload_post_bloc.dart';

@immutable
abstract class UploadPostEvent {}

class PostUploadStarted extends UploadPostEvent {
  final XFile imageFile;
  final String caption;
  final UserModel user;

  PostUploadStarted(this.imageFile, this.caption, this.user);
}
