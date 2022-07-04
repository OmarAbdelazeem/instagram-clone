part of 'upload_post_bloc.dart';

@immutable
abstract class UploadPostEvent {}

class PostUploadStarted extends UploadPostEvent {
  final File imageFile;
  final String caption;
  final UserModel user;

  PostUploadStarted(this.imageFile, this.caption, this.user);
}

class PostEditStarted extends UploadPostEvent {
  final String value;
  final String postId;
  PostEditStarted({required this.value ,required this.postId});
}
