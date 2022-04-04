part of 'upload_photo_bloc.dart';

@immutable
abstract class UploadPhotoState {}

class UploadPhotoInitial extends UploadPhotoState {}

class UploadPhotoLoading extends UploadPhotoState {}

class Error extends UploadPhotoState {
  final String error;

  Error(this.error);
}

class ProfilePhotoAdded extends UploadPhotoState {
  final String profileUrl;

  ProfilePhotoAdded(this.profileUrl);
}
