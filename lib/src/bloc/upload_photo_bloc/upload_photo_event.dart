part of 'upload_photo_bloc.dart';

@immutable
abstract class UploadPhotoEvent {}

class PickProfilePhotoStarted extends UploadPhotoEvent {
  final ImageSource imageSource;
  final String userId;

  PickProfilePhotoStarted(this.imageSource, this.userId);
}

class UploadPostStarted extends UploadPhotoEvent {}
