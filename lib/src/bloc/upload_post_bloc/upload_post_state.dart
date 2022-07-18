part of 'upload_post_bloc.dart';

@immutable
abstract class UploadPostState {}

class UploadPostInitial extends UploadPostState {}

class UpLoadingPost extends UploadPostState {}

class PostUploaded extends UploadPostState {
  final PostModel post;

  PostUploaded(this.post);
}

class Error extends UploadPostState {
  final String error;

  Error(this.error);
}
