import 'dart:async';
import 'dart:io';

import 'package:bloc/bloc.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';
import 'package:instagramapp/src/models/post_model/post_model_request/post_model_request.dart';
import 'package:instagramapp/src/models/post_model/post_model_response/post_model_response.dart';
import 'package:instagramapp/src/repository/data_repository.dart';
import 'package:instagramapp/src/repository/storage_repository.dart';
import 'package:meta/meta.dart';
import 'package:uuid/uuid.dart';

import '../../models/user_model/user_model.dart';
import '../time_line_bloc/time_line_bloc.dart';

part 'upload_post_event.dart';

part 'upload_post_state.dart';

class UploadPostBloc extends Bloc<UploadPostEvent, UploadPostState> {
  final StorageRepository _storageRepository;
  final DataRepository _dataRepository;


  UploadPostBloc(
      this._storageRepository, this._dataRepository)
      : super(UploadPostInitial()) {
    on<PostUploadStarted>(_onPostUploadStarted);
    on<PostEditStarted>(_onEditPostStarted);
  }

  Future<void> _onPostUploadStarted(
      PostUploadStarted event, Emitter<UploadPostState> emit) async {
    emit(UpLoadingPost());
    try {
      final String postId = Uuid().v4();
      final photoUrl = await _storageRepository.uploadPost(
          selectedFile: event.imageFile,
          userId: event.user.id!,
          imageId: postId);
      final post = PostModelRequest(
        caption: event.caption,
        photoUrl: photoUrl,
        postId: postId,
        publisherId: event.user.id!,
        timestamp: Timestamp.now().toDate(),
        likesCount: 0,
        commentsCount: 0,
      );

      await _dataRepository.addPost(post);
      emit(PostUploaded(post));
    } catch (e) {
      print(e.toString());
      emit(Error(e.toString()));
    }
  }

  Future<void> _onEditPostStarted(
      PostEditStarted event, Emitter<UploadPostState> emit) async {
    try {
      emit(EditingPost());
      await _dataRepository.editPostCaption(
          value: event.value, postId: event.postId);
      emit(PostEdited());
    } catch (e) {
      print(e.toString());
      emit(EditPostError(e.toString()));
    }
  }
}
