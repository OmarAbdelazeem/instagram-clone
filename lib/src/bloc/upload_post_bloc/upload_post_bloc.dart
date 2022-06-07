import 'dart:async';
import 'dart:io';

import 'package:bloc/bloc.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';
import 'package:instagramapp/src/repository/data_repository.dart';
import 'package:instagramapp/src/repository/storage_repository.dart';
import 'package:meta/meta.dart';
import 'package:uuid/uuid.dart';

import '../../models/post_model/post_model.dart';
import '../../models/user_model/user_model.dart';

part 'upload_post_event.dart';

part 'upload_post_state.dart';

class UploadPostBloc extends Bloc<UploadPostEvent, UploadPostState> {
  final StorageRepository _storageRepository;
  final DataRepository _dataRepository;

  UploadPostBloc(this._storageRepository, this._dataRepository)
      : super(UploadPostInitial()) {
    on<PostUploadStarted>(_onPostUploadStarted);
  }

  void _onPostUploadStarted(
      PostUploadStarted event, Emitter<UploadPostState> emit) async {
    emit(UpLoadingPost());
    try {
      final photoUrl = await _storageRepository.uploadProfilePhoto(
          selectedFile: event.imageFile, userId: event.user.id!);
      final post = PostModel(
          publisherName: event.user.userName!,
          caption: event.caption,
          photoUrl: photoUrl,
          postId: Uuid().v4(),
          publisherId: event.user.id!,
          timestamp: Timestamp.now().toDate(),
          likesCount: 0,
          commentsCount: 0,
          publisherProfilePhotoUrl: event.user.photoUrl!);

      await _dataRepository.addPost(post);
      emit(PostUploaded());
    } catch (e) {
      print(e.toString());
      emit(Error(e.toString()));
    }
  }
}
